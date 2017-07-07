//
//  CustomCell.swift
//  AAgram
//
//  Created by Mohd Adam on 28/06/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

protocol CommentDelegate {
    func pushComment(CID : Data)
    //1. create this protocol to setup custom delegatation and put every function that u want to use at others
    
}

class CustomCell: UITableViewCell {
    
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!{
        didSet{
            commentButton.addTarget(self, action: #selector(didTapCommentButton(_:)), for: .touchUpInside)
        }
    }
    
    var delegate : CommentDelegate? //2. create the custom delegation
    
    var liked : Bool = false
    var postID : Data?
    var currentUser = Auth.auth().currentUser?.uid
    
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
    
    func didTapCommentButton(_ sender: Any){
        
        //3. create connection
        if let PID = postID {
            self.delegate?.pushComment(CID: PID)
        }

    }
    
    @IBAction func likeButton(_ sender: Any) {
        
        if liked == false {
            
            let ref = Database.database().reference()
            ref.child("posts").child((postID?.pid)!).child("likes").updateChildValues([currentUser!: true])
            
            liked = true
        } else {
            let ref = Database.database().reference()
            ref.child("posts").child((postID?.pid)!).child("likes").child(currentUser!).removeValue()
            liked = false
        }
        
        
    }
    
    

}
