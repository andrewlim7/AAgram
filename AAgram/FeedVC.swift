//
//  FeedVC.swift
//  AAgram
//
//  Created by Andrew Lim on 23/06/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FBSDKLoginKit

class FeedVC: UIViewController {

    @IBOutlet weak var logoutButton: UIButton! {
        didSet{
            logoutButton.addTarget(self, action: #selector(didTapLogoutButton(_:)), for: .touchUpInside)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didTapLogoutButton(_ sender:Any){
        let firebaseAuth = Auth.auth()
        let loginManager = FBSDKLoginManager() //FB system logout
        
        do {
            try firebaseAuth.signOut()  //please ask kh why 2nd logout will reappeared logout
            loginManager.logOut()
            
            print ("Logged out successfully!")
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            return
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    

}
