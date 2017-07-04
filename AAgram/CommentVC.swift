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
            
        }
    }
    
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var postButton: UIButton! {
        didSet{
            postButton.addTarget(self, action: #selector(didTapPostButton(_:)), for: .touchUpInside)
        }
    }
    
    var currentPostID : Data?
    let currentUserID = Auth.auth().currentUser?.uid
    var getUsername : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsernameFromDB()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
    
    func didTapPostButton (_ sender: Any){
        
        guard
            let storeUID = self.currentUserID,
            let getName = self.getUsername
            else { return }
        
        let param : [String : Any] = ["comment": self.commentTextView.text,
                                      "userID": storeUID,
                                      "username": getName,
                                      "postID": currentPostID?.pid,
                                      ]

        
        let commentRef = Database.database().reference().child("comments").childByAutoId()
        commentRef.child((currentPostID?.pid)!).setValue(param)
        
        let postRef = Database.database().reference().child("posts").child("comment")
        postRef.updateChildValues([storeUID:true])
        
        
    }
    
    
}

extension CommentVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let currentRow = indexPath.row
        
        let commentCell : CommentCell = tableView.dequeueReusableCell(withIdentifier: CommentCell.CellIdentifier, for: indexPath) as! CommentCell
        
        commentCell.textView.text = "HELLO"
        commentCell.timeLabel.text = "12.15pm"
        
        return commentCell
    }
    
}
