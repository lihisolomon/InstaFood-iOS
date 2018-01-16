//
//  MyRecipeCell.swift
//  InstaFood
//
//  Created by admin on 07/01/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import SwipeCellKit
class MyRecipeCell: SwipeTableViewCell {
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    
    var myRecipe:Recipe!{
        didSet{
            self.updateUI();
        }
    }
    // MARK: - update ui view
    func updateUI(){
        NetworkingService.sharedInstance.downloadImage(url:myRecipe.picture, uploadImageSuccess)
        recipeTitle.text = myRecipe.title
    }
    
    func uploadImageSuccess(image: UIImage)->(){
        recipeImage.image = image
    }
    
}
