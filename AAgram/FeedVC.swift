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
import SDWebImage

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var logoutButton: UIButton! {
        didSet{
            logoutButton.addTarget(self, action: #selector(didTapLogoutButton(_:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var datas : [Data] = []
    
    var refresher = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        fetchChats()
        
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        refresher.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        tableView.addSubview(refresher)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let currentIndex = 0
        let currentVC = self.tabBarController?.viewControllers
        let nextVC = currentVC![3] as! PostVC
        nextVC.currentTabIndex = currentIndex
    }
    
    func handleRefresh(){
        self.datas.sort(by: {$0.timeStamp > $1.timeStamp})
        refresher.endRefreshing()
        tableView.reloadData()
    }
    
    func didTapLogoutButton(_ sender:Any){
        let firebaseAuth = Auth.auth()
        let loginManager = FBSDKLoginManager() //FB system logout
        
        //if firebaseAuth.currentUser != nil {
            do {
                
                try firebaseAuth.signOut()  //please ask kh why 2nd logout will reappeared logout
                loginManager.logOut()
                
                print ("Logged out successfully!")
                
            } catch let signOutError as NSError {
                
                print ("Error signing out: %@", signOutError)
                return
            }
            
//            self.dismiss(animated: true, completion: nil)
        //}
    }
    
    func fetchChats() {
        
        let ref = Database.database().reference()
        
        ref.child("posts").observe(.childAdded, with: { (snapshot) in
            
            guard let validDictionary = snapshot.value as? [String:Any] else { return }
            
            if let data = Data(withDictionary: validDictionary) {
 
                 self.datas.append(data)
            }
            
            self.datas.sort(by: {$0.timeStamp > $1.timeStamp})
            
            self.tableView.reloadData()
            
            self.tableView.setContentOffset(CGPoint.zero, animated: true)
            
        })

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        
        let data = datas[indexPath.row]
        
        cell.textView?.text = data.caption
        cell.userNameLabel?.text = data.name
        
        cell.mainImageView.sd_setImage(with: data.imageURL, placeholderImage: UIImage(named: "placeholder.png"))
        
        return cell

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
}


