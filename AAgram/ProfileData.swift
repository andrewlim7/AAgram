//
//  ProfileData.swift
//  AAgram
//
//  Created by Andrew Lim on 01/07/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ProfileData{
    
    var name : String?
    var userID : String?
    var imageURL : String?
    var follower: String?
    var following: String?
    
    init?(snapshot: DataSnapshot){
        
        self.userID = snapshot.key
        
        guard let dictionary = snapshot.value as? [String: Any] else { return nil }
    
        if let validName = dictionary["username"] as? String ?? dictionary["name"] {
            self.name = validName as? String
        } else {
            self.name = ""
        }
        
        if let validImageURL = dictionary["profileImageURL"] as? String {
            
            self.imageURL = validImageURL
        } else {
            self.imageURL = ""
        }
        
        if let dictFollower = dictionary["follower"] as? String{
            self.follower = dictFollower
        }else{
            self.follower = ""
        }
        
        if let dictFollowing = dictionary["following"] as? String{
            self.following = dictFollowing
        }else{
            self.following = ""
        }
        
    }
    

    
//    init?(withDictionary dictionary: [String: Any]) {
//        
//        guard
//            
//            let validUser = dictionary["userID"] as? String,
//            let validName = dictionary["username"] as? String
//            else { return nil }
//        
//        self.userID = validUser
//        self.name = validName
//        
//        if let validImageURL = dictionary["profileURL"] as? String {
//            
//            self.imageURL = URL(string: validImageURL)
//        }
//
//    }
    
}
