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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate, CommentDelegate{

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
        tableView.allowsSelection = false
        
        fetchPosts()
        
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
        self.tabBarController?.delegate = self
        
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationItem.title = "AAGram"
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        self.tableView.setContentOffset(CGPoint.zero, animated: true)

    }
    
    func handleRefresh(){
        
        self.datas = []
        fetchPosts()
        refresher.endRefreshing()
        tableView.reloadData()
    }
    
    func didTapLogoutButton(_ sender:Any){
        let firebaseAuth = Auth.auth()
        let loginManager = FBSDKLoginManager() //FB system logout
        
        //if firebaseAuth.currentUser != nil {
            do {
                
                try firebaseAuth.signOut() 
                loginManager.logOut()
                
                print ("Logged out successfully!")
                
            } catch let signOutError as NSError {
                
                print ("Error signing out: %@", signOutError)
                return
            }
            
//            self.dismiss(animated: true, completion: nil)
        //}
    }
    
    func fetchPosts() {
        
        let ref = Database.database().reference()
        
        ref.child("posts").observe(.childAdded, with: { (snapshot) in
            
//            guard let validDictionary = snapshot.value as? [String:Any] else { return }
            
            if let data = Data(snapshot: snapshot) {
                ref.child("users").child(data.userID).observeSingleEvent(of: .value, with: { (userSnapshot) in
                    if let user = ProfileData(snapshot: userSnapshot) {
                        data.profileImage = user.imageURL
                        self.datas.append(data)
                    }
                    self.datas.sort(by: {$0.timeStamp > $1.timeStamp})
                    self.tableView.reloadData()
                })
            }
        })
        

    }
    
    func pushComment(CID : Data) { //1. confirm to the protocol, 2. call the function inside the protocol
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let commentVC = storyboard.instantiateViewController(withIdentifier: "CommentVC") as! CommentVC
        
        commentVC.currentPostID = CID
        
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : CustomCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        
        let data = datas[indexPath.row]
        
        let url = NSURL(string: data.profileImage!)
        cell.profilePicture.sd_setImage(with: url! as URL)
        
        cell.textView?.text = data.caption
        cell.userNameLabel?.text = data.name
        
        cell.mainImageView.sd_setImage(with: data.imageURL, placeholderImage: UIImage(named: "placeholder.png"))
        
        cell.postID = data //get current post index
        
        let ref = Database.database().reference()
        ref.child("posts").child(data.pid).child("likes").observe(.value, with: { (snapshot) in
            if snapshot.hasChild((Auth.auth().currentUser?.uid)!) {
                cell.likeBtn.setImage(UIImage(named: "filled-heart.png"), for: .normal)
                //cell.liked = false
            } else {
                cell.likeBtn.setImage(UIImage(named: "empty-heart.png"), for: .normal)
                //cell.liked = true
            }
        })
        
        ref.child("posts").child(data.pid).child("likes").observe(.value, with: {likesSnapshot in
            
            var count = 0
            count += Int(likesSnapshot.childrenCount)
            cell.likeCountLabel.text = "Total Likes:\(count)"
            
        })
        
        cell.delegate = self //create connection
        
        return cell

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
}


