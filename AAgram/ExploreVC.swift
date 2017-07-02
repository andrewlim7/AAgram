//
//  ExploreVC.swift
//  AAgram
//
//  Created by Andrew Lim on 30/06/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ExploreVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet{
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    @IBOutlet weak var profileImage: UITableViewCell!
    @IBOutlet weak var nameLabel: UILabel!
    
    var userLists : [ProfileData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveUsers()
        
        self.navigationController?.isNavigationBarHidden = false
        

    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func retrieveUsers() {

        let userRef = Database.database().reference()
        userRef.child("users").observe(.childAdded, with: { (snapshot) in
//            guard let validUser = snapshot.value as? [String : Any] else { return }
            
            if snapshot.key == Auth.auth().currentUser?.uid {
                print("\(snapshot.key)")
            } else {
                if let user = ProfileData(snapshot: snapshot) {
                    self.userLists.append(user)
                }
            }
            
            self.tableView.reloadData()
        })
    }

}

extension ExploreVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let currentRow = indexPath.row
        
        cell.textLabel?.text = userLists[currentRow].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        
        let currentRow = indexPath.row
        
        vc.currentUserID = userLists[currentRow].userID
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
