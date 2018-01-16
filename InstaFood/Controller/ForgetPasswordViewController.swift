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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func ForgetPasswordPressed(_ sender: Any) {
        NetworkingService.sharedInstance.ForgotPassword(self, emailTextField.text!)

    }
}
