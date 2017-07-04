//
//  FancyTextfield.swift
//  AAgram
//
//  Created by Mohd Adam on 04/07/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit

class FancyTextfield: UITextField {

    
    override func awakeFromNib() {
        
        let SHADOW_GRAY: CGFloat = 120.0 / 255.0
        
        super.awakeFromNib()
        
        layer.borderColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.2).cgColor
        
        layer.borderWidth = 1.0
        
        layer.cornerRadius = 2.0
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        return bounds.insetBy(dx: 10, dy: 5)
    }

}
