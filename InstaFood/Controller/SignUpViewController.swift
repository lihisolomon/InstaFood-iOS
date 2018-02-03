//
//  SignUpViewController.swift
//  InstaFood
//
//  Created by admin on 19/12/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import SVProgressHUD

class SignUpViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var firstNameTextfield: UITextField!
    @IBOutlet var lastNameTextfield: UITextField!
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet weak var userImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - SignUP
    @IBAction func registerPressed(_ sender: Any) {
        print ("-------------------")
        //register
        SVProgressHUD.show()
        if (firstNameTextfield.text!.isEmpty){
            SVProgressHUD.dismiss()
            ScreenHandler.screenInstance.sendAlertToUser(self, titleAlert: "No First Name", messageAlert: "please type your first name")
        }
        else if (lastNameTextfield.text!.isEmpty){
            SVProgressHUD.dismiss()
            ScreenHandler.screenInstance.sendAlertToUser(self,titleAlert: "No Last Name", messageAlert: "please type your last name")
        }
        else if (!isValidEmail(emailTextfield.text!)){
            SVProgressHUD.dismiss()
            ScreenHandler.screenInstance.sendAlertToUser(self,titleAlert: "invalid email", messageAlert: "please type valid email address")
        }
        else if (!isValidPassword(passwordTextfield.text!)){
            SVProgressHUD.dismiss()
            ScreenHandler.screenInstance.sendAlertToUser(self,titleAlert: "invalid password", messageAlert: "please type passwrod with minimum 6 characters at least 1 Alphabet and 1 Number")
        }
        else {
            UserConnection.userInstance.CreateNewUser(self,emailTextfield.text!,passwordTextfield.text!,self.firstNameTextfield.text!,self.lastNameTextfield.text!, userImageView.image!)
            SVProgressHUD.dismiss()
        }
    }
    
    // MARK: add picture pressed
    @IBAction func addPicturePressed(_ sender: Any) {
        print ("-------------------")
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        ScreenHandler.screenInstance.pickPicture (self,pickerController)
        
        let button = sender as? UIButton
        button?.setTitle("", for: UIControlState.normal)
    }
    
    // MARK: Check password Validation
    func isValidPassword(_ password : String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])[A-Za-z\\d$@$#!%*?&]{6,}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    // MARK: Check Email Validation
    func isValidEmail(_ email : String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format:"SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    // MARK: did Finish Picking Media
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.userImageView.image = image
        }
        picker.dismiss(animated: true, completion: nil);
    }
    
}

