//
//  ForgetPasswordViewController.swift
//  InstaFood
//
//  Created by admin on 23/12/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgetPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    let networkingService = NetworkingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func ForgetPasswordPressed(_ sender: Any) {
        print ("-------------------")
        var titleAlert = ""
        var messageAlert = ""
        var action = ""
        
        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) {error in
            if error == nil {
                print("reset password successfully")
                titleAlert = "Success"
                messageAlert = "An Email to reset password has been sent to you"
                action = "login"
            }
            else {
                print(self.emailTextField.text!)
                print (error!)
                
                titleAlert = "Reset Password Failed"
                messageAlert = "Please check Email Address"
            }
            self.sendAlertToUser(titleAlert: titleAlert, messageAlert: messageAlert, action: action)
        }
    }
    
    // MARK: Send alert to the user
    func sendAlertToUser(titleAlert: String, messageAlert: String, action: String) {
        let alert = UIAlertController(title: titleAlert, message: messageAlert, preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            if action == "login"{
                self.networkingService.MoveToLoginViewController()
            }
            else{
                NSLog("The \"OK\" alert occured.")
            }
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
