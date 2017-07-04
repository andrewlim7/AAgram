//
//  FancyButton.swift
//  AAgram
//
//  Created by Mohd Adam on 04/07/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit

class FancyButton: UIButton {

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        let SHADOW_GRAY: CGFloat = 120.0 / 255.0
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        
        layer.shadowOpacity = 0.8
        
        layer.shadowRadius = 5.0
        
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        layer.cornerRadius = 2.0
    }

}
