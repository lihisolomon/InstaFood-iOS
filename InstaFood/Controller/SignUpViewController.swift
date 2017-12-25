//
//  SignUpViewController.swift
//  InstaFood
//
//  Created by admin on 19/12/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SignUpViewController: UIViewController {

    @IBOutlet var firstNameTextfield: UITextField!
    @IBOutlet var lastNameTextfield: UITextField!
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    let networkingService = NetworkingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - SignUP And move To Feed Bar
    @IBAction func registerPressed(_ sender: Any) {
        print ("-------------------")
        //register
        SVProgressHUD.show()
        if (!isValidEmail(emailTextfield.text!)){
            sendAlertToUser(titleAlert: "invalid email", messageAlert: "please type valid email address")
            SVProgressHUD.dismiss()
        }
        else if (!isValidPassword(passwordTextfield.text!)){
            sendAlertToUser(titleAlert: "invalid password", messageAlert: "please type passwrod with minimum 6 characters at least 1 Alphabet and 1 Number")
            SVProgressHUD.dismiss()
        }
        else {
            Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!, completion: {(user,error) in
                    if error != nil{
                        print (error!)
                    }
                    else {
                        print ("Registration Successfully")
                        SVProgressHUD.dismiss()
                        
                        self.networkingService.moveToFeedBar()
                    }
            })
        }
    }
    
    public func isValidPassword(_ password : String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])[A-Za-z\\d$@$#!%*?&]{6,}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    func isValidEmail(_ email : String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format:"SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    // MARK: Send alert to the user
    func sendAlertToUser(titleAlert: String, messageAlert: String) {
        let alert = UIAlertController(title: titleAlert, message: messageAlert, preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            NSLog("The \"OK\" alert occured.")
        })
        alert.addAction(restartAction)
        self.present(alert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
