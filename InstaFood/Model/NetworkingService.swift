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
import FBSDKCoreKit

struct NetworkingService {
    
    // MARK: - Login user Firebase
    func LoginUser(_ uiViewController: UIViewController,_ email: String ,_ password: String){
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
    
    // MARK: Create a new user use Firebase
    func CreateNewUser(_ uiViewController: UIViewController, _ email: String ,_ password: String,_ firstName: String ,_ lastName: String , _ userImage: UIImage) {
        Auth.auth().createUser(withEmail: email, password: password, completion: {(authData,error) in
            if error != nil{
                print (error!)
                self.sendAlertToUser(uiViewController,titleAlert: "Error, Please Try Again", messageAlert: error!.localizedDescription)
            }
            else {
                guard let uid = authData?.uid else {return }
                
                //successfully authenticated user
                //upload image into Firebase
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
        })
    }
    
    //Mark: upload user data on Firebase - For signOut
    func uploadUserData(_ uid: String, values :[String: AnyObject] ){
        print ("-------------------")
        let ref = Database.database().reference()
        ref.child("users").child(uid).setValue(values)
        
        print ("upload data Successfully")
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
                    let recipeInfo = ["Title" :titleRecipe, "Ingredients" : ingredients, "steps" : stepsRecipe, "RecipeImage": recipeURL, "Likes": String(likesNum)]
                    
                    Database.database().reference().child("Recipes").child(uid).child(uniqID).setValue(recipeInfo)
                    SVProgressHUD.dismiss()
                    print ("upload Recipes data Successfully")
                    //let recipe = Recipe(uid,uniqID,titleRecipe,ingredients,stepsRecipe,pictureRercipe, fullName,likesNum)
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
    
    //Mark: get pictureURL of the current user
    func getUserPicUrl () ->String{
        return Storage.storage().reference().child("ProfileImages").child(getCurrentUID() + ".jpeg").fullPath
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
    
    //MARK: get UIimage from url in firebase
    func getImageFromURL(_ url: String,_ uploadImageSuccess:@escaping (UIImage)->())
    {
        let storageRef = Storage.storage().reference().child(url)
        storageRef.getData(maxSize: 15 * 1024 * 1024)  { (data, error) in
            if error == nil {
                uploadImageSuccess(UIImage(data : data!)!)
            }
            else{
                //print(error)
                print("no picture found \n")
                let image = UIImage(named: "chefImage")
                uploadImageSuccess(image!)
            }
        }
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
            if let folders = snapshot.children.allObjects as? [DataSnapshot]{
                for folder in folders{
                    if folder.key == "Recipes"{
                        if let uids = folder.children.allObjects as? [DataSnapshot]{
                            var recipes = [Recipe]()
                            for uid in uids{
                                var fullName = ""
                                let uidNumber = uid.key
                                for folder in folders{
                                    if folder.key == "users"{
                                        if let users = folder.children.allObjects as? [DataSnapshot]{
                                            for user in users {
                                                if user.key == uidNumber{
                                                    if var userDetals = user.value as? Dictionary<String, AnyObject> {
                                                        let firstName = userDetals["FirstName"] as? String ?? ""
                                                        let lastName = userDetals["LastName"] as? String ?? ""
                                                        fullName = "\(firstName) \(lastName)"
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                if let recipesID = uid.children.allObjects as? [DataSnapshot]{
                                    for recid in recipesID{
                                        let uniqID = recid.key
                                        if var postDict = recid.value as? Dictionary<String, AnyObject> {
                                            let title = postDict["Title"] as? String ?? ""
                                            let steps = postDict["steps"] as? String ?? ""
                                            let ingredients = postDict["Ingredients"] as? String ?? ""
                                            let picture = postDict["RecipeImage"] as? String ?? ""
                                            let numOfLikes = postDict["Likes"] as? String ?? ""
                                            
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

}
