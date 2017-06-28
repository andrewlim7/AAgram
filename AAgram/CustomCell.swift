//
//  CustomCell.swift
//  AAgram
//
//  Created by Mohd Adam on 28/06/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        
        mainImageView.image = nil
    }

}
