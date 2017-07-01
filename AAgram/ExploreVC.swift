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
        }
    }
    @IBOutlet weak var profileImage: UITableViewCell!
    @IBOutlet weak var nameLabel: UILabel!
    
    var userLists : [ProfileData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveUsers()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveUsers() {
        
        let userRef = Database.database().reference()
        userRef.child("users").observe(.childAdded, with: { (snapshot) in
            guard let validUser = snapshot.value as? [String : Any] else { return }
            
            
            if let userList = ProfileData(withDictionary: validUser) {
                self.userLists.append(userList)
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
//        cell.detailTextLabel?.text = userLists[currentRow].userID
        
        return cell
    }
    
    
}
