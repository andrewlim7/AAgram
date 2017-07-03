//
//  SearchVC.swift
//  AAgram
//
//  Created by Andrew Lim on 23/06/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit
import Firebase

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    
    var searchUser : [ProfileData] = []
    var filteredUser : [ProfileData] = []
    var inSearchMode: Bool = false

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        getUsers()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let currentIndex = 1
        let currentVC = self.tabBarController?.viewControllers
        let nextVC = currentVC![3] as! PostVC
        nextVC.currentTabIndex = currentIndex
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func getUsers() {
        
        let userRef = Database.database().reference()
        
        userRef.child("users").observe(.childAdded, with: { (snapshot) in
            
            if let user = ProfileData(snapshot: snapshot) {
                
                self.searchUser.append(user)
            }
            
            self.filteredUser = self.searchUser
            
            self.tableView.reloadData()
            
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredUser.count;
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchCell
        
        let data = filteredUser[indexPath.row]
        
        cell.profileName?.text = data.name
        cell.profileBioLabel.text = data.bio

        let url = NSURL(string: data.imageURL!)
        
        cell.profileImg.sd_setImage(with: url! as URL)

        return cell

    }

    func numberOfSections(in tableView: UITableView) -> Int {
    
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentRow = indexPath.row
        
        inSearchMode = true
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        vc.isSearchingMode = inSearchMode
        
        vc.currentUserID = filteredUser[currentRow].userID
        vc.displayBio = filteredUser[currentRow].bio
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredUser = searchText.isEmpty ? searchUser : searchUser.filter { (item: ProfileData) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return item.name?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        tableView.reloadData()
    }

}
