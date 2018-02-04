//
//  MyRecipesViewController.swift
//  InstaFood
//
//  Created by admin on 29/12/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import SwipeCellKit

class MyRecipesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, SwipeTableViewCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var profileNameLabel: UILabel!
    @IBOutlet var myRecipes: UITableView!

    var recipes: [Recipe]?
    var rowNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get user info
        UserData.userDataInstance.getCurrentFullName(uploadFullName)
        UserData.userDataInstance.getProfileImage(uploadImageSuccess)
        
        //set table view
        self.myRecipes.delegate = self
        self.myRecipes.dataSource = self
        
        self.fetchMyRecipes()
        self.myRecipes.rowHeight = UITableViewAutomaticDimension
        self.myRecipes.rowHeight = 175
        self.myRecipes.backgroundView = UIImageView(image: UIImage(named: DEFAULT_BACKGROUND))
        self.myRecipes.backgroundView?.contentMode = UIViewContentMode.scaleAspectFit
    }
    //MARK: get user's Recipes list
    func fetchMyRecipes(){
        RecipeData.recipeDataInstance.getMyRecipesList(updateMyRecipes: updateMyRecipes)
    }
     //MARK: upload the table view
    func updateMyRecipes(myRecipesArray: [Recipe]){
        self.recipes = myRecipesArray
        self.myRecipes.reloadData()
    }
     //MARK: upload user's image profile
    func uploadImageSuccess(image: UIImage){
        profileImage.image = image
    }
    //MARK: upload user's name
    func uploadFullName(fullName: String){
        self.profileNameLabel.text = fullName
    }
    
    //Mark: user want to change his profile image
    @IBAction func editProfilePictureisPressed(_ sender: UIButton) {
        print ("-------------------")
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        ScreenHandler.screenInstance.pickPicture (self,pickerController)
    }
    // MARK: pick image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profileImage.image = image
        }
        picker.dismiss(animated: true, completion: nil);
        UserData.userDataInstance.uploadUserProfile(self,profileImage.image!)
    }
    
    //Mark: recipe Choosen- need to view the full Recipe details
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("------------------")
        rowNum = indexPath.row
        print ("Recipe \(rowNum) selected")
        performSegue(withIdentifier: "RecipeDetails", sender: self)
    }
    // MARK: segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RecipeDetails" {
            let detailsVC = segue.destination as! RecipeViewViewController
            detailsVC.recipe = self.recipes?[rowNum]
            detailsVC.senderName = "MyRecipes"
        }
    }
    // MARK: Log out
    @IBAction func logoutIsPressed(_ sender: UIButton) {
        ScreenHandler.screenInstance.sendAlertToUserWithTwoOptions(vc: self, title: "Logout", body: "Are you sure you want to log out?", option1: "Logout", option2: "Cancel")
    }
    
    // MARK: table view settings
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.recipes != nil){
            return (self.recipes?.count)!
        }
        else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyRecipeCell", for: indexPath) as! MyRecipeCell
        cell.delegate = self
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.myRecipe = self.recipes?[indexPath.row]
        return cell
    }
    
    //Mark: Delete by swipe
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            RecipeData.recipeDataInstance.removeRecipe(self.recipes![indexPath.row], self.removeSuccess, self.removeFaild)
        }
        deleteAction.image = UIImage(named: "delete")
        return [deleteAction]
    }
    //Mark: Delete from table view
    func removeSuccess(){
        self.myRecipes.reloadData()
    }
    func removeFaild(){
        print ("error")
    }
}
