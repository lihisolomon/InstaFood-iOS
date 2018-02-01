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
        
        NetworkingService.sharedInstance.getCurrentFullName(uploadFullName)
        NetworkingService.sharedInstance.getProfileImage(uploadImageSuccess)
        
        self.myRecipes.delegate = self
        self.myRecipes.dataSource = self
        
        self.fetchMyRecipes()
        self.myRecipes.rowHeight = UITableViewAutomaticDimension
        self.myRecipes.rowHeight = 175
        self.myRecipes.backgroundView = UIImageView(image: UIImage(named: DEFAULT_BACKGROUND))
        self.myRecipes.backgroundView?.contentMode = UIViewContentMode.scaleAspectFit
    }
    
    func fetchMyRecipes(){
        NetworkingService.sharedInstance.getMyRecipesList(updateMyRecipes: updateMyRecipes)
    }
    func updateMyRecipes(myRecipesArray: [Recipe]){
        self.recipes = myRecipesArray
        self.myRecipes.reloadData()
    }
    
    func uploadImageSuccess(image: UIImage){
        profileImage.image = image
    }
    func uploadFullName(fullName: String){
        self.profileNameLabel.text = fullName
    }
    
    //Mark: user want to change his profile image
    @IBAction func editProfilePictureisPressed(_ sender: UIButton) {
        print ("-------------------")
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        NetworkingService.sharedInstance.pickPicture (self,pickerController)
    }
    // MARK: pick image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profileImage.image = image
        }
        picker.dismiss(animated: true, completion: nil);
        NetworkingService.sharedInstance.uploadUserProfile(self,profileImage.image!)
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
        }
    }
    
    @IBAction func logoutIsPressed(_ sender: UIButton) {
        NetworkingService.sharedInstance.sendAlertToUserWithTwoOptions(vc: self, title: "Logout", body: "Are you sure you want to log out?", option1: "Logout", option2: "Cancel")
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
        cell.myRecipe = self.recipes?[indexPath.row]
        return cell
    }
    
    //Mark: Delete by swipe
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            NetworkingService.sharedInstance.removeRecipe(self.recipes![indexPath.row], self.removeSuccess, self.removeFaild)
        }
        deleteAction.image = UIImage(named: "delete")
        return [deleteAction]
    }
    
    func removeSuccess(){
        self.myRecipes.reloadData()
    }
    func removeFaild(){
        print ("error")
    }
}
