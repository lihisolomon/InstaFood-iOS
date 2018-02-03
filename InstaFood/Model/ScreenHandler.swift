//
//  ScreenHandler.swift
//  InstaFood
//
//  Created by admin on 03/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import UIKit

class ScreenHandler {
    
    static let screenInstance = ScreenHandler()
    
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
    
    // MARK: user pick an Image
    func pickPicture(_ uiViewController: UIViewController,_ pickerController: UIImagePickerController){
        let alertController = UIAlertController(title: "Choose Picture", message: "Choose From", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            pickerController.sourceType = .camera
            uiViewController.present(pickerController, animated: true, completion: nil)
        }
        let photosLibraryAction = UIAlertAction(title: "Photos Library", style: .default) { (action) in
            pickerController.sourceType = .photoLibrary
            uiViewController.present(pickerController, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photosLibraryAction)
        alertController.addAction(cancelAction)
        uiViewController.present(alertController, animated: true, completion: nil)
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
    
    // MARK: Send alert to the user with 2 options
    func sendAlertToUserWithTwoOptions(vc: UIViewController, title: String, body: String, option1: String, option2: String) {
        let alert = UIAlertController(title: title, message: body, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: option1, style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            UserConnection.userInstance.signOut()
        }))
        
        alert.addAction(UIAlertAction(title: option2, style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        vc.present(alert, animated: true, completion: nil)
    }
}
