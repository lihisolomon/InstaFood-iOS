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
                let storageRef = Storage.storage().reference().child("ProfileImage\(uid)")
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
            try! Auth.auth().signOut()
            if Auth.auth().currentUser == nil {
                print ("Sign out Successfully")
                MoveToLoginViewController()
            }
        }
        catch let error as NSError{
            print(error.localizedDescription)
        }
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
}
