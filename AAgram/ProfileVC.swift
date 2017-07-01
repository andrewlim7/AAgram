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
    
    
    var imgURL: String = ""
    var profileImgs : [Data] = []
    
    var selectedName: String = ""
    var selectedCaption: String = ""
    var selectedImg: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        fetchChats()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let currentIndex = 2
        let currentVC = self.tabBarController?.viewControllers
        let nextVC = currentVC![3] as! PostVC
        nextVC.currentTabIndex = currentIndex
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
        
        vc.selectedImg = cell.profilePostImgCell.image
        vc.selectedName = profileUsername.text!
        
        self.present(vc, animated: true, completion: nil)

    }

    @IBAction func editProfileBtn(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "EditProfileVC")
        self.present(vc, animated: true, completion: nil)

    }
    
    @IBAction func followBtnPressed(_ sender: Any) {
        
    }
    
    
    func fetchChats() {
        
        let ref = Database.database().reference()
        
        if let user = Auth.auth().currentUser?.uid {
            
            ref.child("users").child(user).observe(.value, with: { (snapshot) in

                guard let dictionary = snapshot.value as? [String:Any] else {
                    
                    return
                }
                
                let username = dictionary["username"] as? String ?? dictionary["name"]
                let profileURL = dictionary["profileImageURL"] as? URL // help me fix this
                
                self.profileUsername.text = username as? String
                self.profileImage.sd_setImage(with: profileURL, placeholderImage: UIImage(named: "placeholder.png")) // this is to load the image
                
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
}
    
    func getPost(_ postID: String) {
        
        let ref = Database.database().reference()
        
        ref.child("posts").child(postID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let validDictionary = snapshot.value as? [String:Any] else { return }
            
            if let data = Data(withDictionary: validDictionary) {
                
                self.profileImgs.append(data)
            }
            
            self.collectionView.reloadData()
        })

    }
    
}
