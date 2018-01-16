//
//  NewRecipeViewController.swift
//  InstaFood
//
//  Created by admin on 29/12/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit


class NewRecipeViewController: UIViewController,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var recipe: Recipe?
    var fullName :String?
    
    @IBOutlet var titleRecipe: UITextView!
    @IBOutlet var ingredients: UITextView!
    @IBOutlet var stepsRecipe: UITextView!
    @IBOutlet var pictureRecipe: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        NetworkingService.sharedInstance.getCurrentFullName(uploadFullName)
    }
    
    // MARK: save button is pressed
    @IBAction func SaveIsPressed(_ sender: UIButton) {
        if titleRecipe.text == "Add Title"{
            NetworkingService.sharedInstance.sendAlertToUser(self, titleAlert: "Title is missing", messageAlert: "please enter the title of the recipe")
        }
        else if ingredients.text == "Add ingredients"{
            NetworkingService.sharedInstance.sendAlertToUser(self, titleAlert: "ingredients is missing", messageAlert: "please enter the ingredients of the recipe")
        }
        else if stepsRecipe.text == "Add steps" {
            NetworkingService.sharedInstance.sendAlertToUser(self, titleAlert: "steps is missing", messageAlert: "please enter the steps of the recipe")
        }
        else if pictureRecipe.image == nil{
            NetworkingService.sharedInstance.sendAlertToUser(self, titleAlert: "image is missing", messageAlert: "please enter the image of the recipe")
        }
        else{
            let uid = NetworkingService.sharedInstance.getCurrentUID()
            let uniqID = NSUUID().uuidString
            NetworkingService.sharedInstance.uploadRecipesData(self,uid:uid ,uniqID:uniqID, titleRecipe.text!,ingredients.text!,stepsRecipe.text!,pictureRecipe.image!,self.fullName!,likesNum: 0, success: success, failure: failure)
        }
    }
    func uploadFullName(fullName: String){
        self.fullName = fullName
    }
    
    func success(recipe: Recipe) {
        print ("Success")
        self.recipe = recipe
        if let recipeViewVC = self.storyboard?.instantiateViewController(withIdentifier: "RecipeViewVC") as? RecipeViewViewController {
            recipeViewVC.recipe = recipe
            self.navigationController?.pushViewController(recipeViewVC, animated: true)
        }
        
    }
    func failure() {
        NetworkingService.sharedInstance.sendAlertToUser(self, titleAlert: "Error", messageAlert: "Error loading new recipe\n please try again")
        print("Could not upload the recipe")
    }
    
    // MARK: add picture is pressed
    @IBAction func addPictureIsPressed(_ sender: UIButton) {
        print ("-------------------")
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        NetworkingService.sharedInstance.pickPicture (self,pickerController)
        
        let button = sender as UIButton
        button.setTitle("", for: UIControlState.normal)
    }
    
    // MARK: pick image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.pictureRecipe.image = image
        }
        picker.dismiss(animated: true, completion: nil);
    }
    
    
    // MARK: - Logout
    @IBAction func Logout(_ sender: UIButton) {
        NetworkingService.sharedInstance.sendAlertToUserWithTwoOptions(vc: self, title: "Logout", body: "Are you sure you want to log out?", option1: "Logout", option2: "Cancel")
    }

    
}
