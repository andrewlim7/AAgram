//
//  Data.swift
//  AAgram
//
//  Created by Mohd Adam on 28/06/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Data {

    var pid : String
    var name: String
    var userID: String
    var timeStamp: Date
    var caption: String?
    var imageURL: URL?
    var profileImage : String?
    
    init?(snapshot: DataSnapshot){
        
        self.pid = snapshot.key
        
        guard
            let dictionary = snapshot.value as? [String: Any],
            let validUser = dictionary["userID"] as? String,
            let validTimestamp = dictionary["timestamp"] as? Double,
            let validName = dictionary["username"] as? String
        else { return nil }
        
        self.userID = validUser
        self.timeStamp = Date(timeIntervalSince1970: validTimestamp)
        self.caption = dictionary["caption"] as? String
        self.name = validName
        
        if let validImageURL = dictionary["imageURL"] as? String {
            
            self.imageURL = URL(string: validImageURL)
        }
    }
    
//    init?(withDictionary dictionary: [String: Any]) {
//        
//        guard
//            
//            let validUser = dictionary["userID"] as? String,
//            let validTimestamp = dictionary["timestamp"] as? Double,
//            let validName = dictionary["username"] as? String
//            else { return nil }
//        
//        self.userID = validUser
//        self.timeStamp = Date(timeIntervalSince1970: validTimestamp)
//        self.caption = dictionary["caption"] as? String
//        self.name = validName
//        
//        if let validImageURL = dictionary["imageURL"] as? String {
//            
//            self.imageURL = URL(string: validImageURL)
//        }
//
//    }

}


