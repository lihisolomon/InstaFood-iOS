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

    let networkingService = NetworkingService()
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
        networkingService.checkIfLike(recipe: recipe!, updateLikeButton: updateLikeButton)
        networkingService.downloadImage(url: (recipe?.picture)!, uploadImageSuccess)
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
            print ("Like this recipe")
            self.setLike()
        }
        else {
            setDontLike()
            print ("Did not like this recipe")
        }
    }
    
    @IBAction func likeIsPressed(_ sender: UIButton) {
        if (isLike.image(for: UIControlState.normal)) == UIImage(named: "fullStarIcon") {
            print ("full, change to empty")
            self.setDontLike()
            
            networkingService.changeLikesNumber(recipe: self.recipe!, action: "Minus")
            networkingService.removeFavoriteRecipe(uid: networkingService.getCurrentUID(),recipe: self.recipe!)
        }
        else{
            print ("empty, change to full")
            self.setLike()
            
            networkingService.changeLikesNumber(recipe: self.recipe!, action: "Plus")
            networkingService.addToFavorites(recipe: self.recipe!)
        }
        
    }
    
    func setLike(){
        isLike.setImage(UIImage(named: "fullStarIcon"), for: UIControlState.normal)
    }
    func setDontLike(){
        isLike.setImage(UIImage(named: "StarIcon"), for: UIControlState.normal)
    }
    
    //Mark: move to feed bar
    @IBAction func FeedIsPressed(_ sender: UIButton) {
        networkingService.moveToFeedBar()
    }
    
    //MARK: sign out
    @IBAction func SignOut(_ sender: UIButton) {
        networkingService.sendAlertToUserWithTwoOptions(vc: self, title: "Logout", body: "Are you sure you want to log out?", option1: "Logout", option2: "Cancel")
    }
    
}
