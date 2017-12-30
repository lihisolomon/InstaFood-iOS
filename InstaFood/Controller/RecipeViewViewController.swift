//
//  RecipeViewViewController.swift
//  InstaFood
//
//  Created by admin on 30/12/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase


class RecipeViewViewController: UIViewController {

    let networkingService = NetworkingService()
    var recipe: Recipe?

    @IBOutlet weak var titleRecipe: UILabel!
    @IBOutlet weak var ingredientsRecipe: UITextView!
    @IBOutlet weak var stepsRecipe: UITextView!
    @IBOutlet weak var pictureRecipe: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        print (recipe?.title)
        titleRecipe.text = recipe?.title
        ingredientsRecipe.text = recipe?.ingredients
        stepsRecipe.text = recipe?.steps
    }
    
    //MARK: sign out
    @IBAction func SignOut(_ sender: UIButton) {
        networkingService.sendAlertToUserWithTwoOptions(vc: self, title: "Logout", body: "Are you sure you want to log out?", option1: "Logout", option2: "Cancel")
    }

}
