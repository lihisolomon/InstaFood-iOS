//
//  ForgetPasswordViewController.swift
//  InstaFood
//
//  Created by admin on 23/12/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class ForgetPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //send email to the user
    @IBAction func ForgetPasswordPressed(_ sender: Any) {
        UserConnection.userInstance.ForgotPassword(self, emailTextField.text!)

    }
}
