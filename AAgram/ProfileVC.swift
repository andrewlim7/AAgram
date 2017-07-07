//
//  ProfileVC.swift
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

class ProfileVC: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var profileFollowers: UILabel!
    @IBOutlet weak var profileFollow: UILabel!
    @IBOutlet weak var profileBio: UILabel!
    @IBOutlet weak var profileUsername: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var followButton: UIButton! {
        didSet{
            followButton.addTarget(self, action: #selector(followBtnPressed(_:)), for: .touchUpInside)
            followButton.isEnabled = false
        }
    }
    
    var imgURL: String = ""
    var profileImgs : [Data] = []
    var currentUserID : String?
    
    var selectedName: String = ""
    var selectedCaption: String = ""
    var selectedImg: UIImage!
    
    var isSearchingMode : Bool?
    var isFollowing : Bool = false
    
    var displayBio : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        fetchPosts()
        
        
        if self.currentUserID == nil {
            
        } else {
            
            followButton.isEnabled = true
            followButton.titleLabel?.textColor = UIColor.white
            followButton.backgroundColor = UIColor.green
            
            let ref = Database.database().reference()
            ref.child("users").child(self.currentUserID!).child("follower").observe(.value, with: { (snapshot) in
                if snapshot.hasChild((Auth.auth().currentUser?.uid)!) {
                    self.followButton.backgroundColor = UIColor.red
                    self.followButton.titleLabel?.text = "Following"
                } else {
                    self.followButton.backgroundColor = UIColor.green
                    self.followButton.titleLabel?.text = "Follow"
                }
            })
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let currentIndex = 2
        let currentVC = self.tabBarController?.viewControllers
        let nextVC = currentVC![3] as! PostVC
        nextVC.currentTabIndex = currentIndex
        self.navigationController?.isNavigationBarHidden = false
        
        
        if isSearchingMode == true {
            
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return profileImgs.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProfileImgCell
        
        let data = profileImgs[indexPath.row]
        
        cell.profilePostImgCell.sd_setImage(with: data.imageURL, placeholderImage: UIImage(named: "placeholder.png"))
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "SelectedImageVC") as! SelectedImageVC
        
        let cell = collectionView.cellForItem(at: indexPath) as! ProfileImgCell
        
        let data = profileImgs[indexPath.row]
        
        vc.selectedImg = cell.profilePostImgCell.image
        vc.selectedName = profileUsername.text!
        vc.selectedProfileImage = self.profileImage.image
        
        vc.postID = data
        
        self.navigationController?.pushViewController(vc, animated: true)

    }

    @IBAction func editProfileBtn(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        
        vc.getBio = self.profileBio.text
        vc.getProfileImage = self.profileImage.image
        
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    func followBtnPressed(_ sender: Any) {
        
        if isFollowing == false {
            let followerRef = Database.database().reference().child("users").child(self.currentUserID!)
            followerRef.child("follower").updateChildValues([(Auth.auth().currentUser?.uid)! : true])
            
            let followingRef = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!)
            followingRef.child("following").updateChildValues([self.currentUserID! : true])
        
            
            isFollowing = true
        } else {
            let followerRef = Database.database().reference().child("users").child(self.currentUserID!)
            followerRef.child("follower").child((Auth.auth().currentUser?.uid)!).removeValue()
            
            let followingRef = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!)
            followingRef.child("following").child(self.currentUserID!).removeValue()
            
        
            
            isFollowing = false

        }

    }
    
    
    func fetchPosts() {
        
        let ref = Database.database().reference()
        
        if self.currentUserID == nil {
            
            if let user = Auth.auth().currentUser?.uid {
                
                ref.child("users").child(user).observe(.value, with: { (snapshot) in
                    
                    guard let dictionary = snapshot.value as? [String:Any] else {
                        
                        return
                    }
                    
                    let username = dictionary["username"] as? String ?? dictionary["name"]
                    let displayBio = dictionary["bio"] as? String
                    
                    if let profileURL = dictionary["profileImageURL"] as? String {
                        let displayUrl = NSURL(string : profileURL)
                        
                        self.profileImage.sd_setImage(with: displayUrl! as URL, placeholderImage: UIImage(named: "placeholder.png"))
                    }
                    
                    self.profileUsername.text = username as? String
                    
                    self.profileBio.text = displayBio
                    
                    self.navigationItem.title = self.profileUsername.text
                    
                    self.profileImgs = []
                    
                    guard let postDictionary = dictionary["post"] as? [String:Any]
                        
                        else { return }
                    
                    self.profileImgs.sort(by: {$0.timeStamp > $1.timeStamp})
                    
                    for (key,_) in postDictionary {
                        
                        self.getPost(key)
                    }
                    
                }) { (error) in
                    
                    print(error.localizedDescription)
                    
                    return
                }
            }

        
        } else {
            
            if let user = self.currentUserID {
                
                ref.child("users").child(user).observe(.value, with: { (snapshot) in
                    
                    guard let dictionary = snapshot.value as? [String:Any] else {
                        
                        return
                    }
                    
                    let username = dictionary["username"] as? String ?? dictionary["name"]
                    let displayBio = dictionary["bio"] as? String
                    
                    if let profileURL = dictionary["profileImageURL"] as? String {
                         let displayUrl = NSURL(string : profileURL)
                        
                        self.profileImage.sd_setImage(with: displayUrl! as URL, placeholderImage: UIImage(named: "placeholder.png"))
                    }
                    
                    self.profileUsername.text = username as? String
                    self.profileBio.text = displayBio
                    
                    self.navigationItem.title = self.profileUsername.text
                    
                    self.profileImgs = []
                    
                    guard let postDictionary = dictionary["post"] as? [String:Any]
                        
                        else { return }
                    
                    for (key,_) in postDictionary {
                        
                        self.getPost(key)
                    }
                    
                }) { (error) in
                    
                    print(error.localizedDescription)
                    
                    return
                }
            }
            
        }
        
    }
    
    func getPost(_ postID: String) {
        
        let ref = Database.database().reference()
        
        ref.child("posts").child(postID).observeSingleEvent(of: .value, with: { (snapshot) in
            
//            guard let validDictionary = snapshot.value as? [String:Any] else { return }
            
            if let data = Data(snapshot: snapshot) {
                
                self.profileImgs.append(data)
            }
            self.profileImgs.sort(by: {$0.timeStamp > $1.timeStamp})
            self.collectionView.reloadData()
        })

    }
    
}
