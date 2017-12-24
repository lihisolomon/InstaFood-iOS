//
//  LoginViewController.swift
//  InstaFood
//
//  Created by admin on 19/12/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Set the Facebook button
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        // MARK: - NEED TO CHANGE TO CONTSRAINTS!!!!!!!!
        loginButton.frame = CGRect(x: 32, y: 565, width: 343, height: 45)
        loginButton.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did logout from facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if (error != nil){
            print (error)
            return
        }
        else {
            print ("Successfully loged in with facebook")
            //go to the Feed Bar
            self.moveToFeedBar()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Login
    @IBAction func LoginPressed(_ sender: Any) {
        print ("-------------------")
        //login
        SVProgressHUD.show()
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            if error != nil {
                print ("-------------------")
                print (error!)
            }
            else {
                print ("login successful")
                SVProgressHUD.dismiss()
                
                //go to the Feed Bar
                self.moveToFeedBar()
            }
        }
        
    }
    
    // MARK: - Login
    func moveToFeedBar() {
        let storyboardMain = UIStoryboard(name: "Main",bundle: nil)
        let tabController = storyboardMain.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = tabController
    }
    
}
