//
//  RecipeData.swift
//  InstaFood
//
//  Created by admin on 03/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import SVProgressHUD

class RecipeData {
    
    static let recipeDataInstance = RecipeData()
    
    //Mark: upload recipes data on Firebase - For signOut
    func uploadRecipesData(_ uiViewController: UIViewController,uid: String,uniqID:String ,_ titleRecipe: String ,_ ingredients: String,_ stepsRecipe: String, _ pictureRercipe: UIImage,_ fullName: String,likesNum: Int, success:@escaping (Recipe)->(), failure:@escaping ()->()){
        print ("-------------------")
        SVProgressHUD.show()
        
        let storageRef = Storage.storage().reference().child("Recipes").child(uid).child("\(uniqID).jpeg")
        if let uploadData = UIImageJPEGRepresentation(pictureRercipe, 0.2){
            storageRef.putData(uploadData, metadata: nil, completion: {(metadata,error) in
                if error != nil{
                    print("Error: \(error!)")
                    failure()
                    return
                }
                else{
                    print ("-------------------")
                    print ("Storage image Successfully")
                }
                if let recipeURL = metadata?.downloadURL()?.absoluteString{
                    let recipeInfo = ["Title" :titleRecipe, "Ingredients" : ingredients, "steps" : stepsRecipe, "RecipeImage": recipeURL, "Likes": String(likesNum),"FullName": fullName]
                    
                    Database.database().reference().child("Recipes").child(uid).child(uniqID).setValue(recipeInfo)
                    SVProgressHUD.dismiss()
                    print ("upload Recipes data Successfully")
                    let recipe = Recipe(uid,uniqID,titleRecipe,ingredients,stepsRecipe,recipeURL, fullName,likesNum)
                    success(recipe)
                }
            })
        }
    }
    
    //MARK: get image from downloadURL
    func downloadImage(url: String, _ uploadImageSuccess:@escaping (UIImage)->()) {
        let ref = Storage.storage().reference(forURL: url)
        ref.getData(maxSize: 15 * 1024 * 1024, completion: { (data, error) in
            if error == nil {
                uploadImageSuccess(UIImage(data : data!)!)
            }
            else{
                //print(error)
                print("no picture found \n")
                let image = UIImage(named: "chefImage")
                uploadImageSuccess(image!)
            }
        })
    }
    
    //MARK: get all recipes
    func getRecipesList(_ updataeRecipes:@escaping ([Recipe])->()){
        SVProgressHUD.show()
        Database.database().reference().observe(.value){snapshot in
            UserDefaults.standard.removeObject(forKey: "recipesArray")
            if let folders = snapshot.children.allObjects as? [DataSnapshot]{
                for folder in folders{
                    if folder.key == "Recipes"{
                        if let uids = folder.children.allObjects as? [DataSnapshot]{
                            var recipes = [Recipe]()
                            for uid in uids{
                                let uidNumber = uid.key
                                if let recipesID = uid.children.allObjects as? [DataSnapshot]{
                                    for recid in recipesID{
                                        let uniqID = recid.key
                                        if var postDict = recid.value as? Dictionary<String, AnyObject> {
                                            let title = postDict["Title"] as? String ?? ""
                                            let steps = postDict["steps"] as? String ?? ""
                                            let ingredients = postDict["Ingredients"] as? String ?? ""
                                            let picture = postDict["RecipeImage"] as? String ?? ""
                                            let numOfLikes = postDict["Likes"] as? String ?? ""
                                            let fullName = postDict["FullName"] as? String ?? ""
                                            recipes.append(Recipe(uidNumber,uniqID,title,ingredients,steps,picture,fullName,Int(numOfLikes)!))
                                        }
                                    }
                                }
                            }
                            
                            updataeRecipes(recipes)
                        }
                    }
                }
            }
        }
        SVProgressHUD.dismiss()
    }
    
    //get user's recipes list
    func getMyRecipesList( updateMyRecipes:@escaping ([Recipe])->()){
        SVProgressHUD.show()
        let curUID = UserConnection.userInstance.getCurrentUID()
        Database.database().reference().child("Recipes").child(curUID).observe(.value){snapshot in
            if let myRecipes = snapshot.children.allObjects as? [DataSnapshot]{
                var recipes = [Recipe]()
                for myRecipe in myRecipes{
                    let uniqID = String(myRecipe.key)
                    if var postDict = myRecipe.value as? Dictionary<String, AnyObject> {
                        let title = postDict["Title"] as? String ?? ""
                        let steps = postDict["steps"] as? String ?? ""
                        let ingredients = postDict["Ingredients"] as? String ?? ""
                        let picture = postDict["RecipeImage"] as? String ?? ""
                        let numOfLikes = postDict["Likes"] as? String ?? ""
                        let fullName = postDict["FullName"] as? String ?? ""
                        recipes.append(Recipe(curUID,uniqID,title,ingredients,steps,picture,fullName,Int(numOfLikes)!))
                    }
                }
                updateMyRecipes(recipes)
            }
        }
        SVProgressHUD.dismiss()
    }
    
    //MARK: get user favourites recipes list
    func getFavoritesList(_ updateFavorites:@escaping ([Recipe])->()){
        SVProgressHUD.show()
        let curUID = UserConnection.userInstance.getCurrentUID()
        Database.database().reference().child("users").child(curUID).child("FavoriteRecipes").observe(.value){snapshot in
            if let favRecipes = snapshot.children.allObjects as? [DataSnapshot]{
                var recipes = [Recipe]()
                for favRecipe in favRecipes{
                    let uniqID = String(favRecipe.key)
                    let uid = favRecipe.value as! String
                    
                    Database.database().reference().child("Recipes").child(uid).child(uniqID).observeSingleEvent(of: .value, with: {(snapshot) in
                        let value = snapshot.value as? NSDictionary
                        let ingredients = value?["Ingredients"] as? String
                        let numOfLikes = value?["Likes"] as? String
                        let picture = value?["RecipeImage"] as? String
                        let title = value?["Title"] as? String
                        let steps = value?["steps"] as? String
                        let fullName = value?["FullName"] as? String
                        recipes.append(Recipe(uid,uniqID,title!,ingredients!,steps!,picture!,fullName!,Int(numOfLikes!)!))
                        updateFavorites(recipes)
                    })
                }
            }
        }
        SVProgressHUD.dismiss()
    }
    
    //MARK: change likes number
    func changeLikesNumber (recipe: Recipe, action: String){
        UserDefaults.standard.removeObject(forKey: "recipesArray")
        if (action == "Minus"){
            Database.database().reference().child("Recipes").child(recipe.uid).child(recipe.uniqId).child("Likes").setValue(String(recipe.likesNum - 1))
        }
        else if (action == "Plus"){
            Database.database().reference().child("Recipes").child(recipe.uid).child(recipe.uniqId).child("Likes").setValue(String(recipe.likesNum + 1))
        }
        else{}
    }
    
    //MARK: remove recipe
    func removeRecipe(_ recipe: Recipe,_ removeSuccess:@escaping ()->(),_ removeFaild:@escaping ()->()){
        Database.database().reference().child("Recipes").child(recipe.uid).child(recipe.uniqId).removeValue{ error, _ in
            if error != nil {
                print("error \(error!)")
                removeFaild()
                return
            }
            else {
                self.removeRecipeFromFavorites(recipe)
                removeSuccess()
            }
        }
    }
    
    //MARK: remove recipe from favorites when recipe was removed
    func removeRecipeFromFavorites(_ recipe: Recipe){
        Database.database().reference().child("users").observe(.value){snapshot in
            if let users = snapshot.children.allObjects as? [DataSnapshot]{
                for user in users{
                    UserData.userDataInstance.removeFavoriteRecipe(uid: user.key, recipe: recipe)
                }
            }
        }
    }
    
    //MARK: upload feed when have a local saving in device - check for new recipes (from othe users) and check the likes number
    func uploadFeed(_ savedrecipes: [Recipe],_ uploadSuccess:@escaping ([Recipe])->()){
        Database.database().reference().child("Recipes").observe(.value){snapshot in
            if let recipesList = snapshot.children.allObjects as? [DataSnapshot]{
                var recipes = [Recipe]()
                for recipe in recipesList{
                    let uidNumber = recipe.key
                    if let recipesID = recipe.children.allObjects as? [DataSnapshot]{
                        for recid in recipesID{
                            let uniqID = recid.key
                            if let found = savedrecipes.filter({ $0.uniqId == uniqID }).first{
                                if var postDict = recid.value as? Dictionary<String, AnyObject> {
                                    let numOfLikes = postDict["Likes"] as? String ?? ""
                                    if Int(numOfLikes) != found.likesNum{
                                        found.likesNum = Int(numOfLikes)!
                                    }
                                    recipes.append(found)
                                }
                            }
                            else{
                                print ("New recipe- need add to feed")
                                if var postDict = recid.value as? Dictionary<String, AnyObject> {
                                    let title = postDict["Title"] as? String ?? ""
                                    let steps = postDict["steps"] as? String ?? ""
                                    let ingredients = postDict["Ingredients"] as? String ?? ""
                                    let picture = postDict["RecipeImage"] as? String ?? ""
                                    let numOfLikes = postDict["Likes"] as? String ?? ""
                                    let fullName = postDict["FullName"] as? String ?? ""
                                    recipes.append(Recipe(uidNumber,uniqID,title,ingredients,steps,picture,fullName,Int(numOfLikes)!))
                                }
                            }
                        }
                    }
                }
                uploadSuccess(recipes)
            }
        }
    }
}
