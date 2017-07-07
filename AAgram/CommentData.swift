//
//  CommentData.swift
//  AAgram
//
//  Created by Andrew Lim on 06/07/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class CommentData {
    
    var cid : String
    var name: String
    var userID: String
    var postID: String
    var timeStamp: Date
    var comment: String?
    var cellProfileImage : String?
    
    init?(snapshot: DataSnapshot){
        
        self.cid = snapshot.key
        
        guard
            let dictionary = snapshot.value as? [String: Any],
            let validUser = dictionary["userID"] as? String,
            let validPID = dictionary["postID"] as? String,
            let validTimestamp = dictionary["timestamp"] as? Double,
            let validName = dictionary["username"] as? String,
            let validComment = dictionary["comment"] as? String

            else { return nil }
        
        self.userID = validUser
        self.timeStamp = Date(timeIntervalSince1970: validTimestamp)
        self.comment = validComment
        self.name = validName
        self.postID = validPID
        
        if let validImageURL = dictionary["profileImageURL"] as? String {
            
            self.cellProfileImage = validImageURL
        } else {
            self.cellProfileImage = ""
        }
    }
}
