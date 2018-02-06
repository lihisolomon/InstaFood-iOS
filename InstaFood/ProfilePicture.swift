//
//  ProfilePicture.swift
//  InstaFood
//
//  Created by admin on 06/02/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class ProfilePicture: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.borderWidth = 0.5
        layer.masksToBounds = false
        layer.borderColor = UIColor.white.cgColor//black.cgColor
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
    }
}

