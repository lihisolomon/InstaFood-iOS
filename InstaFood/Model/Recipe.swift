//
//  Recipe.swift
//  InstaFood
//
//  Created by admin on 30/12/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit

class Recipe{
    var uid: String
    var uniqId: String
    var title: String
    var ingredients: String
    var steps: String
    var picture: UIImage
    var fullName: String
    var likesNum: Int
    
    init(){
        self.uid = ""
        self.uniqId = ""
        self.title = ""
        self.ingredients = ""
        self.steps = ""
        self.picture = UIImage()
        self.fullName = ""
        self.likesNum = 0
    }
    init(_ vuid:String,_ vuniqId: String, _ vtitle: String ,_ vingredients: String,_ vsteps:String,_ vpicture:UIImage,_ vfullName:String,_ vlikesNum: Int) {
        self.uid = vuid
        self.uniqId = vuniqId
        self.title = vtitle
        self.ingredients = vingredients
        self.steps = vsteps
        self.picture = vpicture
        self.fullName = vfullName
        self.likesNum = vlikesNum
    }
}
