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
    
    let myRecipeImagesCache = NSCache<AnyObject, AnyObject>()
    
    var myRecipe:Recipe!{
        didSet{
            self.updateUI();
        }
    }
    // MARK: - update ui view
    func updateUI(){
        self.recipeImage.image = nil
        self.recipeTitle.text = myRecipe.title
        
        //check if have any image in the cache
        if let imageFromCache = myRecipeImagesCache.object(forKey: self.recipeTitle.text as AnyObject){
            self.recipeImage.image = imageFromCache as! UIImage
        }
        else{
            RecipeData.recipeDataInstance.downloadImage(url:myRecipe.picture, uploadImageSuccess)
        }
    }
    //MARK: upload image to cell
    func uploadImageSuccess(image: UIImage)->(){
        //save image to cache
        let imageToCache  = image
        myRecipeImagesCache.setObject(image, forKey: self.recipeTitle.text as AnyObject)
        self.recipeImage.image = imageToCache
    }
    
}
