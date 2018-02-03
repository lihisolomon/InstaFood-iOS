//
//  UserConnection.swift
//  InstaFood
//
//  Created by admin on 03/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import SVProgressHUD
import FBSDKLoginKit
import FBSDKCoreKit

class UserConnection {
    
        static let userInstance = UserConnection()
    
    // MARK: - Login user Firebase
    func LoginUser(_ uiViewController: UIViewController,_ email: String ,_ password: String){
        print ("-------------------")
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print (error!)
                ScreenHandler.screenInstance.sendAlertToUser(uiViewController, titleAlert: "invalid email or password", messageAlert: "please check your inputs")
            }
            else {
                print ("login successful")
                //go to the Feed Bar
                ScreenHandler.screenInstance.moveToFeedBar()
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
                            
                            ScreenHandler.screenInstance.moveToFeedBar()
                            
                            let uid = self.getCurrentUID()
                            Database.database().reference().child("users").observe(.value){snapshot in
                                if let users = snapshot.children.allObjects as? [DataSnapshot]{
                                    for user in users{
                                        if (user.key == uid){
                                            SVProgressHUD.dismiss()
                                            print ("-------------------")
                                            print("User already exist")
                                            return
                                        }
                                    }
                                   UserData.userDataInstance.insertUserToFirebase((user?.email)!, firstName, lastName!, userImage!)
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
    
    // MARK: Create a new user use Firebase
    func CreateNewUser(_ uiViewController: UIViewController, _ email: String ,_ password: String,_ firstName: String ,_ lastName: String , _ userImage: UIImage) {
        Auth.auth().createUser(withEmail: email, password: password, completion: {(authData,error) in
            if error != nil{
                print (error!)
                ScreenHandler.screenInstance.sendAlertToUser(uiViewController,titleAlert: "Error, Please Try Again", messageAlert: error!.localizedDescription)
            }
            else {
                UserData.userDataInstance.insertUserToFirebase(email, firstName, lastName, userImage)
            }
        })
    }
    
    func ForgotPassword(_ uiViewController: UIViewController,_ email : String) {
        print ("-------------------")
        Auth.auth().sendPasswordReset(withEmail: email) {error in
            if error == nil {
                ScreenHandler.screenInstance.sendAlertToUser(uiViewController, titleAlert: "Success", messageAlert: "An Email to reset password has been sent to you",action:"login")
            }
            else {
                print (error!)
                ScreenHandler.screenInstance.sendAlertToUser(uiViewController, titleAlert: "Reset Password Failed", messageAlert: "Please check Email Address")
            }
        }
    }
    
    //MARK: sighOut()
    func signOut(){
        print ("-------------------")
        do {
            try Auth.auth().signOut()
            FBSDKAccessToken.setCurrent(nil)
            print ("Sign out Successfully")
            ScreenHandler.screenInstance.MoveToLoginViewController()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    // MARK: get current user uid
    func getCurrentUID () ->String{
        return (Auth.auth().currentUser?.uid)!
    }
}
