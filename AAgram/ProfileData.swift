//
//  ProfileData.swift
//  AAgram
//
//  Created by Andrew Lim on 01/07/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import Foundation

class ProfileData{
    
    var name : String
    //var userID : String
    var imageURL : URL?

    
    init?(withDictionary dictionary: [String: Any]) {
        
        guard
            
//            let validUser = dictionary["userID"] as? String,
            let validName = dictionary["username"] as? String
            else { return nil }
        
//        self.userID = validUser
        self.name = validName
        
        if let validImageURL = dictionary["profileURL"] as? String {
            
            self.imageURL = URL(string: validImageURL)
        }
        
    }

    
}
