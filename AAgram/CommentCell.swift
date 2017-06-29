//
//  CommentCell.swift
//  AAgram
//
//  Created by Andrew Lim on 29/06/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    @IBOutlet weak var commentImage: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    
    static let cellNib = UINib(nibName: CommentCell.CellIdentifier, bundle: Bundle.main)
    static let CellIdentifier = "CommentCell"
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
