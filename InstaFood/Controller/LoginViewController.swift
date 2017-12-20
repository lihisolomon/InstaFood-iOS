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

class LoginViewController: UIViewController {

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
                let storyboardMain = UIStoryboard(name: "Main",bundle: nil)
                let tabController = storyboardMain.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = tabController
            }
        }
        
    }
    
}
