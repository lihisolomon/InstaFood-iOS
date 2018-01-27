//
//  NetworkingService.swift
//  InstaFood
//
//  Created by admin on 25/12/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import SVProgressHUD
import FBSDKLoginKit
import FBSDKCoreKit

class NetworkingService {
    
    static let sharedInstance = NetworkingService()

    // MARK: - Login user Firebase
    func LoginUser(_ uiViewController: UIViewController,_ email: String ,_ password: String){
         print ("-------------------")
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print (error!)
                self.sendAlertToUser(uiViewController, titleAlert: "invalid email or password", messageAlert: "please check your inputs")
            }
            else {
                print ("login successful")
                //go to the Feed Bar
                self.moveToFeedBar()
            }
        }
    }
    
    func LoginWithFacebook(_ vc: UIViewController, _ failure:@escaping ()->()){
        print ("-------------------")
        FBSDKLoginManager().logIn(withReadPermissions: ["email","public_profile"], from: vc) {(result,error) in
            SVProgressHUD.show()
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id,name,email"]).start(completionHandler: {(connection,result, error) in
                if error != nil {
                    print (error!)
                    failure()
                    SVProgressHUD.dismiss()
                }
                else {
                    let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                    Auth.auth().signIn(with: credential, completion: {(user, error) in
                        if error != nil {
                            print (error!)
                            failure()
                            SVProgressHUD.dismiss()
                        }
                        else {
                            let userImage = UIImage(named: "chefImage")
                            var fullName = (user?.displayName)!
                            var fullNameArr = fullName.characters.split{$0 == " "}.map(String.init)
                            let firstName: String = fullNameArr[0]
                            let lastName: String? = fullNameArr[1]
                            
                            self.moveToFeedBar()
                            
                            let uid = self.getCurrentUID()
                            Database.database().reference().child("users").observe(.value){snapshot in
                                if let users = snapshot.children.allObjects as? [DataSnapshot]{
                                    for user in users{
                                        if (user.key == uid){
//                                        if user.exists(){
//                                            if let loginVC = vc as? LoginViewController{
//                                                loginVC.success()
//                                            }
                                            SVProgressHUD.dismiss()
                                            print ("-------------------")
                                            print("User already exist")
                                            return
                                        }
                                    }
                                    self.insertUserToFirebase((user?.email)!, firstName, lastName!, userImage!)
                                    SVProgressHUD.dismiss()
                                    return
                                }
                            }
                        }
                    })
                }
                
            })
        }
    }
    
    //Mark: Insert new user to Firebase
    func insertUserToFirebase(_ email: String ,_ firstName: String ,_ lastName: String , _ userImage: UIImage){
        print ("-------------------")
        let uid = self.getCurrentUID()
        let storageRef = Storage.storage().reference().child("ProfileImages").child("\(uid).jpeg")
        if let uploadData = UIImageJPEGRepresentation(userImage, 0.2){
            storageRef.putData(uploadData, metadata: nil, completion: {(metadata,error) in
                if error != nil{
                    print("Error")
                    print (error!)
                }
                else{
                    print ("-------------------")
                    print ("Storage image Successfully")
                }
                if let profileUserURL = metadata?.downloadURL()?.absoluteString{
                    let userInfo = ["FirstName" : firstName, "LastName" : lastName, "EmailAddress" : email ,"ProfileImage" : profileUserURL]
                    self.uploadUserData(uid, values: userInfo as [String : AnyObject])
                }
                else {
                    let userInfo = ["FirstName" :firstName, "LastName" : lastName, "EmailAddress" : email]
                    self.uploadUserData(uid, values: userInfo as [String : AnyObject])
                }
            })
        }
        print ("Registration Successfully")
        self.moveToFeedBar()
    }
    
    // MARK: Create a new user use Firebase
    func CreateNewUser(_ uiViewController: UIViewController, _ email: String ,_ password: String,_ firstName: String ,_ lastName: String , _ userImage: UIImage) {
        Auth.auth().createUser(withEmail: email, password: password, completion: {(authData,error) in
            if error != nil{
                print (error!)
                self.sendAlertToUser(uiViewController,titleAlert: "Error, Please Try Again", messageAlert: error!.localizedDescription)
            }
            else {
                self.insertUserToFirebase(email, firstName, lastName, userImage)
            }
        })
    }
    
    //Mark: upload user data on Firebase - For signOut
    func uploadUserData(_ uid: String, values :[String: AnyObject] ){
        print ("-------------------")
        let ref = Database.database().reference()
        ref.child("users").child(uid).setValue(values)
        
        print ("upload data Successfully")
    }
    
    func uploadUserProfile (_ uiViewController: UIViewController,_ profileImage:UIImage){
        let uid = self.getCurrentUID()
        
        let storageRef = Storage.storage().reference().child("ProfileImages").child("\(uid).jpeg")
        storageRef.delete { error in
            if error != nil{
                print("Error")
                print (error!)
                self.sendAlertToUser(uiViewController, titleAlert: "Error", messageAlert: "Error while changing profile photo, Please try again")
            }
            else{
                print ("-------------------")
                print ("Image deleted Successfully")
                if let uploadData = UIImageJPEGRepresentation(profileImage, 0.2){
                    storageRef.putData(uploadData, metadata: nil, completion: {(metadata,error) in
                        if error != nil{
                            print("Error")
                            print (error!)
                        }
                        else{
                            if let profileUserURL = metadata?.downloadURL()?.absoluteString{
                                Database.database().reference().child("users").child(uid).child("ProfileImage").setValue(profileUserURL)
                            }
                            print ("-------------------")
                            print ("change image Successfully")
                        }
                    })
                }
            }
        }
    }
    
    func ForgotPassword(_ uiViewController: UIViewController,_ email : String) {
        print ("-------------------")
        Auth.auth().sendPasswordReset(withEmail: email) {error in
            if error == nil {
                self.sendAlertToUser(uiViewController, titleAlert: "Success", messageAlert: "An Email to reset password has been sent to you",action:"login")
            }
            else {
                print (error!)
                self.sendAlertToUser(uiViewController, titleAlert: "Reset Password Failed", messageAlert: "Please check Email Address")
            }
        }
    }
    
    func signOut(){
        print ("-------------------")
        do {
            try Auth.auth().signOut()
            FBSDKAccessToken.setCurrent(nil)
            print ("Sign out Successfully")
            MoveToLoginViewController()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    //Mark: upload recipes data on Firebase - For signOut
    func uploadRecipesData(_ uiViewController: UIViewController,uid: String,uniqID:String ,_ titleRecipe: String ,_ ingredients: String,_ stepsRecipe: String, _ pictureRercipe: UIImage,_ fullName: String,likesNum: Int, success:@escaping (Recipe)->(), failure:@escaping ()->()){
        print ("-------------------")
        SVProgressHUD.show()
        
        let storageRef = Storage.storage().reference().child("Recipes").child(uid).child("\(uniqID).jpeg")
        if let uploadData = UIImageJPEGRepresentation(pictureRercipe, 0.2){
            storageRef.putData(uploadData, metadata: nil, completion: {(metadata,error) in
                if error != nil{
                    print("Error: \(error!)")
                    failure()
                    return
                }
                else{
                    print ("-------------------")
                    print ("Storage image Successfully")
                }
                if let recipeURL = metadata?.downloadURL()?.absoluteString{
                    let recipeInfo = ["Title" :titleRecipe, "Ingredients" : ingredients, "steps" : stepsRecipe, "RecipeImage": recipeURL, "Likes": String(likesNum),"FullName": fullName]
                    
                    Database.database().reference().child("Recipes").child(uid).child(uniqID).setValue(recipeInfo)
                    SVProgressHUD.dismiss()
                    print ("upload Recipes data Successfully")
                    let recipe = Recipe(uid,uniqID,titleRecipe,ingredients,stepsRecipe,recipeURL, fullName,likesNum)
                    success(recipe)
                }
            })
        }
    }
    // MARK: get current user uid
    func getCurrentUID () ->String{
        return (Auth.auth().currentUser?.uid)!
    }
    
    // MARK: - Move To Feed Bar View Controller
    func moveToFeedBar() {
        let storyboardMain = UIStoryboard(name: "Main",bundle: nil)
        let tabController = storyboardMain.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = tabController
    }
    
    
    // MARK: - Move To Login View Controller
    func MoveToLoginViewController() {
        let storyboardMain = UIStoryboard(name: "Main",bundle: nil)
        let loginsView = storyboardMain.instantiateViewController(withIdentifier: "Root") as! UINavigationController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginsView
    }
    
    // MARK: Send alert to the user
    func sendAlertToUser(_ uiViewController: UIViewController, titleAlert: String, messageAlert: String) {
        let alert = UIAlertController(title: titleAlert, message: messageAlert, preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            NSLog("The \"OK\" alert occured.")
        })
        alert.addAction(restartAction)
        uiViewController.present(alert, animated: true, completion: nil)
    }
    
    // MARK: user pick an Image
    func pickPicture(_ uiViewController: UIViewController,_ pickerController: UIImagePickerController){
        let alertController = UIAlertController(title: "Choose Picture", message: "Choose From", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            pickerController.sourceType = .camera
            uiViewController.present(pickerController, animated: true, completion: nil)
        }
        let photosLibraryAction = UIAlertAction(title: "Photos Library", style: .default) { (action) in
            pickerController.sourceType = .photoLibrary
            uiViewController.present(pickerController, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photosLibraryAction)
        alertController.addAction(cancelAction)
        uiViewController.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Send alert to the user with action param
    func sendAlertToUser(_ uiViewController: UIViewController, titleAlert: String, messageAlert: String, action: String) {
        let alert = UIAlertController(title: titleAlert, message: messageAlert, preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            if action == "login"{
                self.MoveToLoginViewController()
            }
            else{
                NSLog("The \"OK\" alert occured.")
            }
        })
        alert.addAction(restartAction)
        uiViewController.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Send alert to the user with 2 options
    func sendAlertToUserWithTwoOptions(vc: UIViewController, title: String, body: String, option1: String, option2: String) {
        let alert = UIAlertController(title: title, message: body, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: option1, style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            self.signOut()
        }))
        
        alert.addAction(UIAlertAction(title: option2, style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    //MARK: get profile image
    func getProfileImage(_ uploadImageSuccess:@escaping (UIImage)->()){
        let uid = self.getCurrentUID()

        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let profileImage = value?["ProfileImage"] as! String
            self.downloadImage(url:profileImage, uploadImageSuccess)
        })
    }
    
    //MARK: get image from downloadURL
    func downloadImage(url: String, _ uploadImageSuccess:@escaping (UIImage)->()) {
        let ref = Storage.storage().reference(forURL: url)
        ref.getData(maxSize: 15 * 1024 * 1024, completion: { (data, error) in
            if error == nil {
                uploadImageSuccess(UIImage(data : data!)!)
            }
            else{
                //print(error)
                print("no picture found \n")
                let image = UIImage(named: "chefImage")
                uploadImageSuccess(image!)
            }
        })
    }
    
    //MARK: get full name of current user
    func getCurrentFullName(_ uploadFullName:@escaping (String)->()){
        let uid = self.getCurrentUID()
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let firstName = value?["FirstName"] as? String
            let lastName = value?["LastName"] as? String
            let name = firstName! + " " + lastName!
            uploadFullName(name)
        })
    }
    
    
    //MARK: get all recipes
    func getRecipesList(_ updataeRecipes:@escaping ([Recipe])->()){
        SVProgressHUD.show()
        Database.database().reference().observe(.value){snapshot in
            UserDefaults.standard.removeObject(forKey: "recipesArray")
            if let folders = snapshot.children.allObjects as? [DataSnapshot]{
                for folder in folders{
                    if folder.key == "Recipes"{
                        if let uids = folder.children.allObjects as? [DataSnapshot]{
                            var recipes = [Recipe]()
                            for uid in uids{
                                let uidNumber = uid.key
                                if let recipesID = uid.children.allObjects as? [DataSnapshot]{
                                    for recid in recipesID{
                                        let uniqID = recid.key
                                        if var postDict = recid.value as? Dictionary<String, AnyObject> {
                                            let title = postDict["Title"] as? String ?? ""
                                            let steps = postDict["steps"] as? String ?? ""
                                            let ingredients = postDict["Ingredients"] as? String ?? ""
                                            let picture = postDict["RecipeImage"] as? String ?? ""
                                            let numOfLikes = postDict["Likes"] as? String ?? ""
                                            let fullName = postDict["FullName"] as? String ?? ""
                                            recipes.append(Recipe(uidNumber,uniqID,title,ingredients,steps,picture,fullName,Int(numOfLikes)!))
                                        }
                                    }
                                }
                            }
                            
                            updataeRecipes(recipes)
                        }
                    }
                }
            }
        }
        SVProgressHUD.dismiss()
    }
    
    //get user's recipes list
    func getMyRecipesList( updateMyRecipes:@escaping ([Recipe])->()){
        SVProgressHUD.show()
        let curUID = self.getCurrentUID()
        Database.database().reference().child("Recipes").child(curUID).observe(.value){snapshot in
            if let myRecipes = snapshot.children.allObjects as? [DataSnapshot]{
                var recipes = [Recipe]()
                for myRecipe in myRecipes{
                    let uniqID = String(myRecipe.key)
                    if var postDict = myRecipe.value as? Dictionary<String, AnyObject> {
                        let title = postDict["Title"] as? String ?? ""
                        let steps = postDict["steps"] as? String ?? ""
                        let ingredients = postDict["Ingredients"] as? String ?? ""
                        let picture = postDict["RecipeImage"] as? String ?? ""
                        let numOfLikes = postDict["Likes"] as? String ?? ""
                        let fullName = postDict["FullName"] as? String ?? ""
                        recipes.append(Recipe(curUID,uniqID,title,ingredients,steps,picture,fullName,Int(numOfLikes)!))
                    }
                }
                updateMyRecipes(recipes)
            }
        }
        SVProgressHUD.dismiss()
    }
    
    //MARK: get user favourites recipes list
    func getFavoritesList(_ updateFavorites:@escaping ([Recipe])->()){
        SVProgressHUD.show()
        let curUID = self.getCurrentUID()
        Database.database().reference().child("users").child(curUID).child("FavoriteRecipes").observe(.value){snapshot in
            if let favRecipes = snapshot.children.allObjects as? [DataSnapshot]{
                var recipes = [Recipe]()
                for favRecipe in favRecipes{
                    let uniqID = String(favRecipe.key)
                    let uid = favRecipe.value as! String
                    
                    Database.database().reference().child("Recipes").child(uid).child(uniqID).observeSingleEvent(of: .value, with: {(snapshot) in
                        let value = snapshot.value as? NSDictionary
                        let ingredients = value?["Ingredients"] as? String
                        let numOfLikes = value?["Likes"] as? String
                        let picture = value?["RecipeImage"] as? String
                        let title = value?["Title"] as? String
                        let steps = value?["steps"] as? String
                        let fullName = value?["FullName"] as? String
                        recipes.append(Recipe(uid,uniqID,title!,ingredients!,steps!,picture!,fullName!,Int(numOfLikes!)!))
                        updateFavorites(recipes)
                    })
                }
            }
        }
        SVProgressHUD.dismiss()
    }
    
    //MARK: change likes number
    func changeLikesNumber (recipe: Recipe, action: String){
        UserDefaults.standard.removeObject(forKey: "recipesArray")
        if (action == "Minus"){
            Database.database().reference().child("Recipes").child(recipe.uid).child(recipe.uniqId).child("Likes").setValue(String(recipe.likesNum - 1))
        }
        else if (action == "Plus"){
            Database.database().reference().child("Recipes").child(recipe.uid).child(recipe.uniqId).child("Likes").setValue(String(recipe.likesNum + 1))
        }
        else{}
    }
    
    //MARK: add recipe to favorites
    func addToFavorites(recipe: Recipe){
        let curUID = self.getCurrentUID()
        Database.database().reference().child("users").child(curUID).child("FavoriteRecipes").child(recipe.uniqId).setValue(recipe.uid)
    }
    //MARK: remove recipe from favorites
    func removeFavoriteRecipe(uid:String,recipe: Recipe){
        //self.getCurrentUID()
        Database.database().reference().child("users").child(uid).child("FavoriteRecipes").child(recipe.uniqId).removeValue()
    }
    
    //MARK: check if user likes the recipe
    func checkIfLike(recipe: Recipe, updateLikeButton:@escaping (Bool)->()){
        let curUID = self.getCurrentUID()
        Database.database().reference().child("users").child(curUID).child("FavoriteRecipes").observe(.value){snapshot in
            //UserDefaults.standard.removeObject(forKey: "recipesArray")
            if let recipes = snapshot.children.allObjects as? [DataSnapshot]{
                for rec in recipes{
                    if (rec.key == recipe.uniqId){
                        updateLikeButton(true)
                        return
                    }
                }
                updateLikeButton(false)
            }
        }
    }
    
    //MARK: remove recipe
    func removeRecipe(_ recipe: Recipe,_ removeSuccess:@escaping ()->(),_ removeFaild:@escaping ()->()){
        Database.database().reference().child("Recipes").child(recipe.uid).child(recipe.uniqId).removeValue{ error, _ in
            if error != nil {
                print("error \(error!)")
                removeFaild()
                return
            }
            else {
                self.removeRecipeFromFavorites(recipe)
                removeSuccess()
            }
        }
    }
    
    func removeRecipeFromFavorites(_ recipe: Recipe){
        Database.database().reference().child("users").observe(.value){snapshot in
            if let users = snapshot.children.allObjects as? [DataSnapshot]{
                for user in users{
                    self.removeFavoriteRecipe(uid: user.key, recipe: recipe)
                }
            }
        }
    }
    
    func uploadFeed(_ savedrecipes: [Recipe],_ uploadSuccess:@escaping ([Recipe])->()){
        Database.database().reference().child("Recipes").observe(.value){snapshot in
            if let recipesList = snapshot.children.allObjects as? [DataSnapshot]{
                var recipes = [Recipe]()
                for recipe in recipesList{
                    let uidNumber = recipe.key
                    if let recipesID = recipe.children.allObjects as? [DataSnapshot]{
                        for recid in recipesID{
                            let uniqID = recid.key
                            if let found = savedrecipes.filter({ $0.uniqId == uniqID }).first{
                                    if var postDict = recid.value as? Dictionary<String, AnyObject> {
                                        let numOfLikes = postDict["Likes"] as? String ?? ""
                                        if Int(numOfLikes) != found.likesNum{
                                            found.likesNum = Int(numOfLikes)!
                                            recipes.append(found)
                                        }
                                        recipes.append(found)
                                    }
                                }
                                else{
                                    print ("New recipe- need add to feed")
                                    if var postDict = recid.value as? Dictionary<String, AnyObject> {
                                        let title = postDict["Title"] as? String ?? ""
                                        let steps = postDict["steps"] as? String ?? ""
                                        let ingredients = postDict["Ingredients"] as? String ?? ""
                                        let picture = postDict["RecipeImage"] as? String ?? ""
                                        let numOfLikes = postDict["Likes"] as? String ?? ""
                                        let fullName = postDict["FullName"] as? String ?? ""
                                        recipes.append(Recipe(uidNumber,uniqID,title,ingredients,steps,picture,fullName,Int(numOfLikes)!))
                                    }
                                }
                        }
                    }
                }
                 uploadSuccess(recipes)
            }
        }
    }
}
//if let uids = folder.children.allObjects as? [DataSnapshot]{
//    var recipes = [Recipe]()
//    for uid in uids{
//        let uidNumber = uid.key
//        if let recipesID = uid.children.allObjects as? [DataSnapshot]{
//            for recid in recipesID{
//                let uniqID = recid.key
//                if var postDict = recid.value as? Dictionary<String, AnyObject> {
//                    let title = postDict["Title"] as? String ?? ""
//                    let steps = postDict["steps"] as? String ?? ""
//                    let ingredients = postDict["Ingredients"] as? String ?? ""
//                    let picture = postDict["RecipeImage"] as? String ?? ""
//                    let numOfLikes = postDict["Likes"] as? String ?? ""
//                    let fullName = postDict["FullName"] as? String ?? ""
//                    recipes.append(Recipe(uidNumber,uniqID,title,ingredients,steps,picture,fullName,Int(numOfLikes)!))
//                }
//            }
//        }
//    }
//}

