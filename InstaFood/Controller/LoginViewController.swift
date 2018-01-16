//
//  LoginViewController.swift
//  InstaFood
//
//  Created by admin on 19/12/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import SVProgressHUD


class LoginViewController: UIViewController {//, FBSDKLoginButtonDelegate {
    
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginWithFacebook(_ sender: UIButton) {
        NetworkingService.sharedInstance.LoginWithFacebook(self, failure)
    }
    func failure(){
        NetworkingService.sharedInstance.sendAlertToUser(self, titleAlert: "Error", messageAlert: "Failed login with facebook")
    }
    
    // MARK: - Login
    @IBAction func LoginPressed(_ sender: Any) {
        //login
        SVProgressHUD.show()
        
        NetworkingService.sharedInstance.LoginUser(self, emailTextfield.text!, passwordTextfield.text!)
        
        SVProgressHUD.dismiss()
    }
}

