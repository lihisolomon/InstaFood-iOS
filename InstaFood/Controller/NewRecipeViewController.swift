//
//  NewRecipeViewController.swift
//  InstaFood
//
//  Created by admin on 29/12/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit


class NewRecipeViewController: UIViewController,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let networkingService = NetworkingService()
    var recipe: Recipe?
    
    @IBOutlet weak var titleRecipe: UITextView!
    @IBOutlet weak var ingredients: UITextView!
    @IBOutlet weak var stepsRecipe: UITextView!
    @IBOutlet weak var pictureRecipe: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    // MARK: save button is pressed
    @IBAction func SaveIsPressed(_ sender: UIButton) {
        if titleRecipe.text == "Add Title"{
            networkingService.sendAlertToUser(self, titleAlert: "Title is missing", messageAlert: "please enter the title of the recipe")
        }
        else if ingredients.text == "Add ingredients"{
            networkingService.sendAlertToUser(self, titleAlert: "ingredients is missing", messageAlert: "please enter the ingredients of the recipe")
        }
        else if stepsRecipe.text == "Add steps" {
            networkingService.sendAlertToUser(self, titleAlert: "steps is missing", messageAlert: "please enter the steps of the recipe")
        }
        else if pictureRecipe.image == nil{
            networkingService.sendAlertToUser(self, titleAlert: "image is missing", messageAlert: "please enter the image of the recipe")
        }
        else{
            networkingService.uploadRecipesData(self,titleRecipe.text!,ingredients.text!,stepsRecipe.text!,pictureRecipe.image!, success: success, failure: failure)
        }
    }
    
    func success(uid: String,recipeID: String, recipe: Recipe) {
        print ("Success")
        self.recipe = recipe
        if let recipeViewVC = self.storyboard?.instantiateViewController(withIdentifier: "RecipeViewVC") as? RecipeViewViewController {
            recipeViewVC.recipe = recipe
            self.navigationController?.pushViewController(recipeViewVC, animated: true)
        }
        
    }
    func failure() {
        networkingService.sendAlertToUser(self, titleAlert: "Error", messageAlert: "Error loading new recipe\n please try again")
        print("Could not upload the recipe")
    }
    
    // MARK: add picture is pressed
    @IBAction func addPictureIsPressed(_ sender: UIButton) {
        print ("-------------------")
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        networkingService.pickPicture (self,pickerController)
        
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
        networkingService.sendAlertToUserWithTwoOptions(vc: self, title: "Logout", body: "Are you sure you want to log out?", option1: "Logout", option2: "Cancel")
    }

    
}
