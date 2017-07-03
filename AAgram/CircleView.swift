//
//  CircleView.swift
//  AAgram
//
//  Created by Mohd Adam on 03/07/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit

class CircleView: UIImageView {
    
        override func layoutSubviews() {
            
            super.layoutSubviews()
            
            layer.cornerRadius = self.frame.width / 2
            
            clipsToBounds = true
        }
        
    }


