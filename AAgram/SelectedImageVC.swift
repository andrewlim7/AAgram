//
//  SelectedImageVC.swift
//  AAgram
//
//  Created by Mohd Adam on 27/06/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit
import Firebase

class SelectedImageVC: UIViewController {
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var selectedImgView: UIImageView!
    @IBOutlet weak var selectedProfPic: UIImageView!
    @IBOutlet weak var numberOfLikes: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!{
        didSet{
            commentBtn.addTarget(self, action: #selector(didTapCommentBtn(_:)), for: .touchUpInside)
        }
    }
    
    var selectedName: String = ""
    var selectedCaption: String = ""
    var selectedImg: UIImage!
    var selectedProfileImage : UIImage?

    var postID : Data?
    var liked : Bool = false
    var currentUser = Auth.auth().currentUser?.uid
    
    static let CellIdentifer = "SelectedImageVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        usernameLabel.text = selectedName
        captionTextView.text = selectedCaption
        selectedImgView.image = selectedImg
        selectedProfPic.image = selectedProfileImage
        
        
        let ref = Database.database().reference()
        
        ref.child("posts").child((postID?.pid)!).child("likes").observe(.value, with: { (snapshot) in
            if snapshot.hasChild((Auth.auth().currentUser?.uid)!) {
                self.likeBtn.tintColor = UIColor.blue
                //cell.liked = false
            } else {
                self.likeBtn.tintColor = UIColor.black
                //cell.liked = true
            }
        })
        
        ref.child("posts").child((postID?.pid)!).child("likes").observe(.value, with: {likesSnapshot in
            
            var count = 0
            count += Int(likesSnapshot.childrenCount)
            self.numberOfLikes.text = "Total Likes:\(count)"
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    @IBAction func likeBtnPressed(_ sender: Any) {
        
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
    
    func didTapCommentBtn(_ sender : Any){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let commentVC = storyboard.instantiateViewController(withIdentifier: "CommentVC") as! CommentVC
        
        
        
        self.navigationController?.pushViewController(commentVC, animated: true)
        
    }
    
}
