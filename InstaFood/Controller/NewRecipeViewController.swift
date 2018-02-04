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
        UserData.userDataInstance.getCurrentFullName(uploadFullName)
    }
    
    // MARK: save button is pressed
    @IBAction func SaveIsPressed(_ sender: UIButton) {
        if titleRecipe.text.isEmpty{
            ScreenHandler.screenInstance.sendAlertToUser(self, titleAlert: "Title is missing", messageAlert: "please enter the title of the recipe")
        }
        else if ingredients.text.isEmpty{
            ScreenHandler.screenInstance.sendAlertToUser(self, titleAlert: "ingredients is missing", messageAlert: "please enter the ingredients of the recipe")
        }
        else if stepsRecipe.text.isEmpty{
            ScreenHandler.screenInstance.sendAlertToUser(self, titleAlert: "steps is missing", messageAlert: "please enter the steps of the recipe")
        }
        else if pictureRecipe.image == nil{
            ScreenHandler.screenInstance.sendAlertToUser(self, titleAlert: "image is missing", messageAlert: "please enter the image of the recipe")
        }
        else{
            let uid = UserConnection.userInstance.getCurrentUID()
            let uniqID = NSUUID().uuidString
            RecipeData.recipeDataInstance.uploadRecipesData(self,uid:uid ,uniqID:uniqID, titleRecipe.text!,ingredients.text!,stepsRecipe.text!,pictureRecipe.image!,self.fullName!,likesNum: 0, success: success, failure: failure)
        }
    }
    func uploadFullName(fullName: String){
        self.fullName = fullName
    }
    //if the recipe upload successfully - move to recipe view
    func success(recipe: Recipe) {
        print ("Success")
        self.recipe = recipe
        if let recipeViewVC = self.storyboard?.instantiateViewController(withIdentifier: "RecipeViewVC") as? RecipeViewViewController {
            recipeViewVC.recipe = recipe
            recipeViewVC.senderName = "AddRecipe"
            self.navigationController?.pushViewController(recipeViewVC, animated: true)
        }
    }
    func failure() {
        ScreenHandler.screenInstance.sendAlertToUser(self, titleAlert: "Error", messageAlert: "Error loading new recipe\n please try again")
        print("Could not upload the recipe")
    }
    
    // MARK: add picture is pressed
    @IBAction func addPictureIsPressed(_ sender: UIButton) {
        print ("-------------------")
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        ScreenHandler.screenInstance.pickPicture (self,pickerController)
        
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
        ScreenHandler.screenInstance.sendAlertToUserWithTwoOptions(vc: self, title: "Logout", body: "Are you sure you want to log out?", option1: "Logout", option2: "Cancel")
    }

    
}
