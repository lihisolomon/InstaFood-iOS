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
                let storageRef = Storage.storage().reference().child("ProfileImages").child("\(uid).png")
                if let uploadData = UIImagePNGRepresentation(userImage){
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
    func uploadRecipesData(_ uiViewController: UIViewController, _ titleRecipe: String ,_ ingredients: String,_ stepsRecipe: String, _ pictureRercipe: UIImage, success:@escaping (String,String,Recipe)->(), failure:@escaping ()->()){
        print ("-------------------")
        SVProgressHUD.show()
        let uid = Auth.auth().currentUser?.uid
        let uniqName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("Recipes").child(uid!).child("\(uniqName).png")
        if let uploadData = UIImagePNGRepresentation(pictureRercipe){
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
                    let recipeInfo = ["Title" :titleRecipe, "Ingredients" : ingredients, "steps" : stepsRecipe, "RecipeImage": recipeURL]
                    Database.database().reference().child("Recipes").child(uid!).child(uniqName).setValue(recipeInfo)
                    SVProgressHUD.dismiss()
                    print ("upload Recipes data Successfully")
                    //self.sendAlertToUser(uiViewController, titleAlert: "Success", messageAlert: "inserted new recipe successfuly",action: "RecipeView")
                    //self.sendAlertToUser(uiViewController, titleAlert: "Success", messageAlert: "inserted new recipe successfuly")
                    let recipe = Recipe(titleRecipe,ingredients,stepsRecipe,recipeURL)
                   success(uid!,uniqName,recipe)
                }
            })
        }
    }
    // MARK: - Display new recipe data לא למחוק
//    func displayRecipeData(uid: String, recipeNum: String) -> Recipe{
//        print ("-------------------")
//        var recipe : Recipe?
//        let ref = Database.database().reference()
//        ref.child("Recipes").child(uid).child(recipeNum).observeSingleEvent (of: .value, with: { (snapshot)  in
//            if let recipeDict = snapshot.value as? Dictionary<String, AnyObject> {
//                let title = recipeDict["Title"] as? String ?? ""
//                let steps = recipeDict["steps"] as? String ?? ""
//                let ingredients = recipeDict["Ingredients"] as? String ?? ""
//                let picture = recipeDict["RecipeImage"] as? String ?? ""
//                let recipe = Recipe(title,ingredients,steps,picture)
//            }
//
//        }){ (error) in
//            print(error.localizedDescription)
//        }
//        return recipe!
//    }
    
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
    
    // MARK: - Move To Recipe View View Controller
    func MoveToRecipeViewController() {
        let storyboardMain = UIStoryboard(name: "Main",bundle: nil)
        let recipeView = storyboardMain.instantiateViewController(withIdentifier: "RecipeView") as! UIViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = recipeView
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
            else if action == "RecipeView"{
                self.MoveToRecipeViewController()
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
    
    func getCurrentUserPic() ->UIImage {
        var pic:UIImage?
        let uid = Auth.auth().currentUser?.uid
        let storageRef = Storage.storage().reference().child("ProfileImage\(uid)")
        storageRef.getData(maxSize: 1*1000*1000)  { (data, error) in
            if error == nil {
                pic = UIImage(data : data!)!
            }
            else{
                //print(error)
                print("no picture found \n")
                Storage.storage().reference().child("default chef.png").getData(maxSize: 1*1000*1000)  { (data, error) in
                    pic = UIImage(data : data!)!
                }
            }
        }
        return pic!
    }
    
    func getCurrentUserName() -> String{
        let uid = Auth.auth().currentUser?.uid
        var name : String = ""
        Database.database().reference().child("users\(uid)").observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let firstName = value?["FirstName"] as? String
            let lastName = value?["LastName"] as? String
            name = firstName! + " " + lastName!
        })
        
        return name
    }
    
}

