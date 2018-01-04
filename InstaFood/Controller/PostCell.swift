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
    @IBOutlet weak var numberOfLike: UIButton!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var writerName: UILabel!
    
    var post:Recipe!{
        didSet{
            self.updateUI();
        }
    }
    // MARK: - update ui view
    func updateUI(){
        RecipeImage.image = post.picture
        recipeName.text = post.title
        writerName.text = post.fullName
        numberOfLike.setTitle("test lihi", for: [])
    }
}
