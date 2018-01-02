//
//  Profile.swift
//  InstaFood
//
//  Created by admin on 02/01/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class Profile {
    var uid: String
    var picture: UIImage
    var fullName: String
    
    init(){
        self.uid = ""
        self.picture = UIImage()
        self.fullName = ""
    }
    
    init(vpicture:UIImage,_ vfullName:String,_ vuid:String) {
    self.uid = vuid
    self.picture = vpicture
    self.fullName = vfullName
    }
}
