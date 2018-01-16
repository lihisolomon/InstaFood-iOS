//
//  PostCell.swift
//  InstaFood
//
//  Created by admin on 03/01/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    
    @IBOutlet weak var RecipeImage: UIImageView!
    @IBOutlet weak var numberOfLikes: UILabel!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var writerName: UILabel!
    
    var post:Recipe!{
        didSet{
            self.updateUI();
        }
    }
    // MARK: - update ui view
    func updateUI(){
        NetworkingService.sharedInstance.downloadImage(url: post.picture, uploadImageSuccess)
        writerName.text = post.fullName
        recipeName.text = post.title
        numberOfLikes.text = "🖤 \(post.likesNum) Likes"
    }

    
    func uploadImageSuccess(image: UIImage)->(){
        RecipeImage.image = image
    }
}
