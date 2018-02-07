//
//  UserData.swift
//  InstaFood
//
//  Created by admin on 03/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import SVProgressHUD

class UserData {
    
    static let userDataInstance = UserData()
    
    //Mark: Insert new user to Firebase
    func insertUserToFirebase(_ email: String ,_ firstName: String ,_ lastName: String , _ userImage: UIImage){
        print ("-------------------")
        let uid = UserConnection.userInstance.getCurrentUID()
        let storageRef = Storage.storage().reference().child("ProfileImages").child("\(uid).jpeg")
        if let uploadData = UIImageJPEGRepresentation(userImage, 0.2){
            storageRef.putData(uploadData, metadata: nil, completion: {(metadata,error) in
                if error != nil{
                    print("Error")
                    print (error!)
                }
                else{
                    print ("-------------------")
                    print ("Storage image Successfully")
                }
                if let profileUserURL = metadata?.downloadURL()?.absoluteString{
                    let userInfo = ["FirstName" : firstName, "LastName" : lastName, "EmailAddress" : email ,"ProfileImage" : profileUserURL]
                    self.uploadUserData(uid, values: userInfo as [String : AnyObject])
                }
                else {
                    let userInfo = ["FirstName" :firstName, "LastName" : lastName, "EmailAddress" : email]
                    self.uploadUserData(uid, values: userInfo as [String : AnyObject])
                }
            })
        }
        print ("Registration Successfully")
        ScreenHandler.screenInstance.moveToFeedBar()
    }
    
    //Mark: upload user data on Firebase - For signOut
    func uploadUserData(_ uid: String, values :[String: AnyObject] ){
        print ("-------------------")
        let ref = Database.database().reference()
        ref.child("users").child(uid).setValue(values)
        
        print ("upload data Successfully")
    }
    
    //MARK: upload new profile image
    func uploadUserProfile (_ uiViewController: UIViewController,_ profileImage:UIImage){
        let uid = UserConnection.userInstance.getCurrentUID()
        
        let storageRef = Storage.storage().reference().child("ProfileImages").child("\(uid).jpeg")
        storageRef.delete { error in
            if error != nil{
                print("Error")
                print (error!)
                ScreenHandler.screenInstance.sendAlertToUser(uiViewController, titleAlert: "Error", messageAlert: "Error while changing profile photo, Please try again")
            }
            else{
                print ("-------------------")
                print ("Image deleted Successfully")
                if let uploadData = UIImageJPEGRepresentation(profileImage, 0.2){
                    storageRef.putData(uploadData, metadata: nil, completion: {(metadata,error) in
                        if error != nil{
                            print("Error")
                            print (error!)
                        }
                        else{
                            if let profileUserURL = metadata?.downloadURL()?.absoluteString{
                                Database.database().reference().child("users").child(uid).child("ProfileImage").setValue(profileUserURL)
                            }
                            print ("-------------------")
                            print ("change image Successfully")
                        }
                    })
                }
            }
        }
    }
    
    //MARK: get profile image
    func getProfileImage(_ uid: String ,_ uploadImageSuccess:@escaping (UIImage)->()){
        //let uid = UserConnection.userInstance.getCurrentUID()
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let profileImage = value?["ProfileImage"] as! String
            RecipeData.recipeDataInstance.downloadImage(url:profileImage, uploadImageSuccess)
        })
    }
    
    //MARK: get full name of current user
    func getCurrentFullName(_ uploadFullName:@escaping (String)->()){
        let uid = UserConnection.userInstance.getCurrentUID()
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let firstName = value?["FirstName"] as? String
            let lastName = value?["LastName"] as? String
            let name = firstName! + " " + lastName!
            uploadFullName(name)
        })
    }
    
    //MARK: add recipe to favorites
    func addToFavorites(recipe: Recipe){
        let curUID = UserConnection.userInstance.getCurrentUID()
        Database.database().reference().child("users").child(curUID).child("FavoriteRecipes").child(recipe.uniqId).setValue(recipe.uid)
    }
    //MARK: remove recipe from favorites
    func removeFavoriteRecipe(uid:String,recipe: Recipe){
        //self.getCurrentUID()
        Database.database().reference().child("users").child(uid).child("FavoriteRecipes").child(recipe.uniqId).removeValue()
    }
    
    //MARK: check if user likes the recipe
    func checkIfLike(recipe: Recipe, updateLikeButton:@escaping (Bool)->()){
        let curUID = UserConnection.userInstance.getCurrentUID()
        Database.database().reference().child("users").child(curUID).child("FavoriteRecipes").observe(.value){snapshot in
            //UserDefaults.standard.removeObject(forKey: "recipesArray")
            if let recipes = snapshot.children.allObjects as? [DataSnapshot]{
                for rec in recipes{
                    if (rec.key == recipe.uniqId){
                        updateLikeButton(true)
                        return
                    }
                }
                updateLikeButton(false)
            }
        }
    }
}
