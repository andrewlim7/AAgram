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
    var inSearchMode = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
        getUsers()
        
        self.navigationController?.isNavigationBarHidden = false
        
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
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        inSearchMode = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        inSearchMode = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        inSearchMode = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        inSearchMode = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredUser = searchUser.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        
        if(filteredUser.count == 0){
            
            inSearchMode = false
            
        } else {
            
            inSearchMode = true
        }
        
        self.tableView.reloadData()
    }
    
    func getUsers() {
        
        let userRef = Database.database().reference()
        
        userRef.child("users").observe(.childAdded, with: { (snapshot) in
            
            if let user = ProfileData(snapshot: snapshot) {
                
                self.searchUser.append(user)
            }
            
            self.tableView.reloadData()
            
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if(inSearchMode) {
            return filteredUser.count
        }
        return searchUser.count;
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchCell
        
        if(inSearchMode){
            
            let data = filteredUser[indexPath.row]
            cell.profileName?.text = data.name
            
        } else {
            
            let data = searchUser[indexPath.row]
            cell.profileName?.text = data.name
        }

        return cell

    }

    func numberOfSections(in tableView: UITableView) -> Int {
    
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        
        let currentRow = indexPath.row
        
        vc.currentUserID = searchUser[currentRow].userID
        vc.isOtherUsingProfile = true
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}
