//
//  RecipeViewViewController.swift
//  InstaFood
//
//  Created by admin on 30/12/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import SVProgressHUD

class RecipeViewViewController: UIViewController {

    var recipe: Recipe?

    @IBOutlet var isLike: UIButton!
    @IBOutlet var titleRecipe: UILabel!
    @IBOutlet var ingredientsRecipe: UITextView!
    @IBOutlet var stepsRecipe: UITextView!
    @IBOutlet var pictureRecipe: UIImageView!
    @IBOutlet var writerRecipe: UITextView!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        UserData.userDataInstance.checkIfLike(recipe: recipe!, updateLikeButton: updateLikeButton)
        RecipeData.recipeDataInstance.downloadImage(url: (recipe?.picture)!, uploadImageSuccess)
        titleRecipe.text = recipe?.title
        ingredientsRecipe.text = recipe?.ingredients
        stepsRecipe.text = recipe?.steps
        writerRecipe.text = recipe?.fullName
    }
    
    func uploadImageSuccess(image: UIImage)->(){
        pictureRecipe.image = image
    }
    func updateLikeButton(isLike: Bool){
        print ("-------------------")
        if isLike{
            //print ("Like this recipe")
            self.setLike()
        }
        else {
            setDontLike()
            //print ("Did not like this recipe")
        }
    }
    
    //MARK: like recipe
    @IBAction func likeIsPressed(_ sender: UIButton) {
        if (isLike.image(for: UIControlState.normal)) == UIImage(named: "fullStarIcon") {
            print ("full, change to empty")
            self.setDontLike()
            
            RecipeData.recipeDataInstance.changeLikesNumber(recipe: self.recipe!, action: "Minus")
            UserData.userDataInstance.removeFavoriteRecipe(uid: UserConnection.userInstance.getCurrentUID(),recipe: self.recipe!)
        }
        else{
            print ("empty, change to full")
            self.setLike()
            
            RecipeData.recipeDataInstance.changeLikesNumber(recipe: self.recipe!, action: "Plus")
            UserData.userDataInstance.addToFavorites(recipe: self.recipe!)
        }
    }
    //MARK: change to like picture
    func setLike(){
        isLike.setImage(UIImage(named: "fullStarIcon"), for: UIControlState.normal)
    }
    //MARK: change to unlike picture
    func setDontLike(){
        isLike.setImage(UIImage(named: "StarIcon"), for: UIControlState.normal)
    }
    
    //Mark: move to feed bar
    @IBAction func FeedIsPressed(_ sender: UIButton) {
        ScreenHandler.screenInstance.moveToFeedBar()
        //self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: sign out
    @IBAction func SignOut(_ sender: UIButton) {
        ScreenHandler.screenInstance.sendAlertToUserWithTwoOptions(vc: self, title: "Logout", body: "Are you sure you want to log out?", option1: "Logout", option2: "Cancel")
    }
    
}
