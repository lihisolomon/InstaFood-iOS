//
//  FavoriteCell.swift
//  InstaFood
//
//  Created by admin on 07/01/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    
    let myFavoritesImagesCache = NSCache<AnyObject, AnyObject>()
    
    var favorite:Recipe!{
        didSet{
            self.updateUI();
        }
    }

    // MARK: - update ui view
    func updateUI(){
        self.recipeImage.image = nil
        self.recipeTitle.text = favorite.title
        
        //check if have any image in the cache
        if let imageFromCache = myFavoritesImagesCache.object(forKey: self.recipeTitle.text as AnyObject){
            self.recipeImage.image = imageFromCache as! UIImage
        }
        else{
            NetworkingService.sharedInstance.downloadImage(url: favorite.picture, uploadImageSuccess)
        }
    }
    //MARK: upload image to cell
    func uploadImageSuccess(image: UIImage)->(){
        //save image to cache
        let imageToCache  = image
        myFavoritesImagesCache.setObject(image, forKey: self.recipeTitle.text as AnyObject)
        self.recipeImage.image = imageToCache
    }

}
