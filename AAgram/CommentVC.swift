//
//  CommentVC.swift
//  AAgram
//
//  Created by Andrew Lim on 29/06/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CommentVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet{
            tableView.dataSource = self
            tableView.register(CommentCell.cellNib, forCellReuseIdentifier: CommentCell.CellIdentifier)
            tableView.rowHeight = 120
        }
    }
    
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var postButton: UIButton! {
        didSet{
            postButton.addTarget(self, action: #selector(didTapPostButton(_:)), for: .touchUpInside)
        }
    }
    
    var refresher = UIRefreshControl()
    var currentPostID : Data?
    let currentUserID = Auth.auth().currentUser?.uid
    var getUsername : String?
    var getUserProfilePic : UIImage?
    var storeComments : [CommentData] = []
    var displayName : String?
    var displayComment : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsernameFromDB()
        loadCommentsFromDB()
        
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        refresher.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        tableView.addSubview(refresher)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func handleRefresh(){
        
        self.storeComments = []
        loadCommentsFromDB()
        refresher.endRefreshing()
        tableView.reloadData()
    }
    
    func getUsernameFromDB(){
        let uid = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("users").child(uid!).observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:Any],
                let name = dictionary["username"] as? String {
                self.getUsername = name
            }
        })
        
    }
    
    func loadCommentsFromDB() {
        
        if let currentPID = self.currentPostID?.pid {
            
            let commentRef = Database.database().reference().child("posts")
            commentRef.child(currentPID).child("comment").observe(.value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String:Any] else {
                    
                    return
                }
                
                self.storeComments = []
            
                for (key,_) in dictionary {
                    
                    self.getCommments(key)
                }
                
            })
            
        }
        

        
        
    }
    
    func getCommments(_ commentID: String) {
        
        let ref = Database.database().reference()
        
        ref.child("comments").child(commentID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let data = CommentData(snapshot: snapshot) {
                
                self.storeComments.append(data)
            }
            self.storeComments.sort(by: {$0.timeStamp < $1.timeStamp})
            self.tableView.reloadData()
        })
        
    }
    
    func didTapPostButton (_ sender: Any){
        
        guard
            let storeUID = self.currentUserID,
            let getName = self.getUsername,
            let getCurrentPostID = currentPostID?.pid
            else { return }
        
        let now = Date()
        let param : [String : Any] = ["comment": self.commentTextView.text,
                                      "userID": storeUID,
                                      "username": getName,
                                      "postID": getCurrentPostID,
                                      "timestamp": now.timeIntervalSince1970
                                      ]

        
        let commentRef = Database.database().reference().child("comments").childByAutoId()
        let storeCID = commentRef.key
        
        commentRef.updateChildValues(param)
        
        let postRef = Database.database().reference().child("posts").child(getCurrentPostID).child("comment")
        postRef.updateChildValues([storeCID:true])
        
        self.commentTextView.text = nil
    }
    
    
}

extension CommentVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.storeComments.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let commentCell : CommentCell = tableView.dequeueReusableCell(withIdentifier: CommentCell.CellIdentifier, for: indexPath) as! CommentCell
        
        if indexPath.row == 0 {
            if self.getUserProfilePic != nil{
                commentCell.commentImage.image = self.getUserProfilePic
            } else{
                commentCell.commentImage.sd_setImage(with: currentPostID?.imageURL)
            }
            
            commentCell.textView.text = self.currentPostID?.caption
            commentCell.timeLabel.text = "12.15"
            commentCell.nameLabel.text = self.currentPostID?.name
            commentCell.isEditing = false
            
            return commentCell
            
        } else {
            
            let currentRow = self.storeComments[indexPath.row - 1]
            
            
            
            commentCell.commentImage.sd_setImage(with: currentPostID?.imageURL)
            
            
            commentCell.textView.text = currentRow.comment
//            commentCell.timeLabel.text = currentRow.timeStamp
            commentCell.nameLabel.text = currentRow.name
            commentCell.isEditing = false

            return commentCell
            
        }

    }
    
}
