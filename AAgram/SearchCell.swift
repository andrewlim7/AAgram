//
//  SearchCell.swift
//  AAgram
//
//  Created by Mohd Adam on 02/07/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
