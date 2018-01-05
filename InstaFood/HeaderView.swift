//
//  HeaderView.swift
//  InstaFood
//
//  Created by admin on 05/01/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class HeaderView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        let shadowPath = UIBezierPath(rect: bounds)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        layer.shadowOpacity = 0.2
        layer.shadowPath = shadowPath.cgPath
    }
}
