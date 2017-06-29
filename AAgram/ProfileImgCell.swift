//
//  ProfileImgCell.swift
//  AAgram
//
//  Created by Mohd Adam on 29/06/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit

class ProfileImgCell: UICollectionViewCell {
    
    @IBOutlet weak var profilePostImgCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        
        profilePostImgCell.image = nil
    }
    
}
