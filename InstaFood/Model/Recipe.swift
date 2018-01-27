//
//  Recipe.swift
//  InstaFood
//
//  Created by admin on 30/12/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit

class Recipe : NSObject, NSCoding{
    var uid: String
    var uniqId: String
    var title: String
    var ingredients: String
    var steps: String
    var picture: String
    var fullName: String
    var likesNum: Int
    
    override init(){
        self.uid = ""
        self.uniqId = ""
        self.title = ""
        self.ingredients = ""
        self.steps = ""
        self.picture = ""
        self.fullName = ""
        self.likesNum = 0
    }
    init(_ vuid:String,_ vuniqId: String, _ vtitle: String ,_ vingredients: String,_ vsteps:String,_ vpicture:String,_ vfullName:String,_ vlikesNum: Int) {
        self.uid = vuid
        self.uniqId = vuniqId
        self.title = vtitle
        self.ingredients = vingredients
        self.steps = vsteps
        self.picture = vpicture
        self.fullName = vfullName
        self.likesNum = vlikesNum
    }
    
    //For saving data locally
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.uid, forKey: "uid")
        aCoder.encode(self.uniqId, forKey: "uniqId")
        aCoder.encode(self.title, forKey: "titleRecipe")
        aCoder.encode(self.ingredients, forKey: "ingredientsRecipe")
        aCoder.encode(self.steps, forKey: "stepsRecipe")
        aCoder.encode(self.picture, forKey: "pictureURL")
        aCoder.encode(self.fullName, forKey: "fullName")
        aCoder.encode(String(self.likesNum), forKey: "likesNumOfRecipe")
    }
    
    //For saving data locally
    required init?(coder aDecoder: NSCoder) {
        self.uid = aDecoder.decodeObject(forKey: "uid") as! String
        self.uniqId = aDecoder.decodeObject(forKey: "uniqId") as! String
        self.title = aDecoder.decodeObject(forKey: "titleRecipe") as! String
        self.ingredients = aDecoder.decodeObject(forKey: "ingredientsRecipe") as! String
        self.steps = aDecoder.decodeObject(forKey: "stepsRecipe") as! String
        self.picture = aDecoder.decodeObject(forKey: "pictureURL") as! String
        self.fullName = aDecoder.decodeObject(forKey: "fullName") as! String
        self.likesNum = Int(aDecoder.decodeObject(forKey: "likesNumOfRecipe") as! String)!
    }
}
