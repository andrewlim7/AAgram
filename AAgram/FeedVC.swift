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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var logoutButton: UIButton! {
        didSet{
            logoutButton.addTarget(self, action: #selector(didTapLogoutButton(_:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var datas : [Data] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        fetchChats()
        let currentIndex = 0
        let currentVC = self.tabBarController?.viewControllers
        let nextVC = currentVC![3] as! PostVC
        nextVC.currentTabIndex = currentIndex
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
//        let uid = Auth.auth().currentUser?.uid
        
        ref.child("posts").observe(.childAdded, with: { (snapshot) in
            
            guard let validDictionary = snapshot.value as? [String:Any] else { return }
            
            if let data = Data(withDictionary: validDictionary) {
                
                self.datas.append(data)
            }
            
            self.tableView.reloadData()
            
//            let scrollPoint = CGPoint(x:0, y:self.tableView.contentSize.height - self.tableView.frame.size.height)
//            self.tableView.setContentOffset(scrollPoint, animated: true)
            
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
        
        cell.mainImageView?.loadImageFromURL(data.imageURL)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
}

extension UIImageView {
    
    func loadImageFromURL (_ imageURL: URL?) {
        
        guard let validImageURL = imageURL else { return }
        
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        
        let dataTask = urlSession.dataTask(with: validImageURL) { (data, response, error) in
            
            if let validData = data {
                
                let downloadedImage = UIImage(data: validData)
                
                self.image = downloadedImage
            }
        }
        
        dataTask.resume()
    }
}
