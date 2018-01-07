//
//  FavoriteCell.swift
//  InstaFood
//
//  Created by admin on 07/01/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell {

     let networkingService = NetworkingService()

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    
    var favorite:Recipe!{
        didSet{
            self.updateUI();
        }
    }

    // MARK: - update ui view
    func updateUI(){
        networkingService.downloadImage(url: favorite.picture, uploadImageSuccess)
        recipeTitle.text = favorite.title
    }
    func uploadImageSuccess(image: UIImage)->(){
        recipeImage.image = image
    }
    
    @IBAction func unlikeIsPressed(_ sender: UIButton) {
    }
}
