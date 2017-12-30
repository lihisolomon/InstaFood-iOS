//
//  Recipe.swift
//  InstaFood
//
//  Created by admin on 30/12/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation

class Recipe{
    var title: String
    var ingredients: String
    var steps: String
    var picture: String
    
    init(){
        self.title = ""
        self.ingredients = ""
        self.steps = ""
        self.picture = ""
    }
    init(_ vtitle: String ,_ vingredients: String,_ vsteps:String,_ vpicture:String) {
        self.title = vtitle
        self.ingredients = vingredients
        self.steps = vsteps
        self.picture = vpicture
    }
}
