//
//  PostCell.swift
//  InstaFood
//
//  Created by admin on 03/01/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    static let postsImagesCache = NSCache<AnyObject, AnyObject>()
    
    @IBOutlet weak var RecipeImage: UIImageView!
    @IBOutlet weak var numberOfLikes: UILabel!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var writerName: UILabel!
    @IBOutlet weak var userProfile: ProfilePicture!
    
    var post:Recipe!{
        didSet{
            self.updateUI();
        }
    }
    // MARK: - update ui view
    func updateUI(){
        self.RecipeImage.image = nil
        self.userProfile.image = nil
        
        //UserData.userDataInstance.getProfileImage(post.uid,uploadImageprofileSuccess)
        writerName.text = post.fullName
        recipeName.text = post.title
        
         //check if have any Profile image in the cache
        if let imageFromCache = PostCell.postsImagesCache.object(forKey: self.post.uid as AnyObject){
            self.userProfile.image = imageFromCache as! UIImage
        }
        else{
           UserData.userDataInstance.getProfileImage(post.uid,uploadImageprofileSuccess)
        }
        
        //check if have any recipe image in the cache
        if let imageFromCache = PostCell.postsImagesCache.object(forKey: self.recipeName.text as AnyObject){
            self.RecipeImage.image = imageFromCache as! UIImage
        }
        else{
            RecipeData.recipeDataInstance.downloadImage(url: post.picture, uploadImageSuccess)
        }
        numberOfLikes.text = "🖤 \(post.likesNum) Likes"
    }

    //MARK: upload image to cell
    func uploadImageSuccess(image: UIImage)->(){
        //save image to cache
        let imageToCache  = image
        PostCell.postsImagesCache.setObject(imageToCache, forKey: self.recipeName.text as AnyObject)
        self.RecipeImage.image = imageToCache
    }
    
    //MARK: upload user's image profile
    func uploadImageprofileSuccess(image: UIImage){
        let imageToCache  = image
        PostCell.postsImagesCache.setObject(imageToCache, forKey: self.post.uid as AnyObject)
        self.userProfile.image = imageToCache
    }
    
    
}
