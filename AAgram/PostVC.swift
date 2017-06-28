//
//  PostVC.swift
//  AAgram
//
//  Created by Andrew Lim on 23/06/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class PostVC: UIViewController,UITabBarControllerDelegate {
    
    @IBOutlet weak var doneButton: UIButton!{
        didSet{
            doneButton.addTarget(self, action: #selector(doneButtonTapped(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var textView: UITextView! {
        didSet{
            textView.text = ""
        }
    }
    
    var isNewPost : Bool = true
    
    var getUsername : String = ""
    var currentTabIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsernameFromDB()
        getFBNameFromDB()
        self.tabBarController?.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isNewPost == true {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            present(pickerController, animated: true, completion: nil)
            isNewPost = false
        }

    }
    
    func getUsernameFromDB(){
        let uid = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("users").child(uid!).observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:Any],
                let name = dictionary["username"] as? String {
                self.getUsername = name
            }
        })

    }
    
    func getFBNameFromDB(){
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:Any],
                let name = dictionary["name"] as? String {
                self.getUsername = name
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addPictureAndCaption(_ caption: String!, imageURL: String!){
        
        guard
            let uid = Auth.auth().currentUser?.uid,
            let validCaption = caption,
            let validImageURL = imageURL
            else { return }
        
        let now = Date()
        let param : [String:Any] = ["userID" : uid,
                                    "username" : self.getUsername,
                                    "timestamp": now.timeIntervalSince1970,
                                    "imageURL": validImageURL,
                                    "caption": validCaption]
        
        let ref = Database.database().reference().child("posts").childByAutoId()
        ref.setValue(param)
        
        let currentPID = ref.key
        print(currentPID)
        
        let updateUserPID = Database.database().reference().child("users").child(uid).child("post")
        updateUserPID.updateChildValues([currentPID: true])
        
        textView.text = nil
        
    }
    
    func doneButtonTapped(_ sender: Any){
        self.doneButton.isEnabled = false
        let storageRef = Storage.storage().reference()
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        guard let data = UIImageJPEGRepresentation(imageView.image!, 0.8) else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        let uuid = UUID().uuidString
        print(uuid)
        
        storageRef.child("\(uuid).jpg").putData(data, metadata: metadata) { (newMeta, error) in
            if (error != nil) {
                // Uh-oh, an error occurred!
                print(error!)
            } else {
                
                defer{
                    self.dismiss(animated: true, completion: nil) //so the return function will return this
                }
                
                if let foundError = error {
                    print(foundError.localizedDescription)
                    return
                }
                
                guard let imageURL = newMeta?.downloadURLs?.first?.absoluteString else {
                    return
                }
                
                //method 2 directly download from URL which is using extension
                self.addPictureAndCaption(self.textView.text, imageURL: imageURL)
            }
            self.isNewPost = true
            self.tabBarController?.selectedIndex = 0 //change the tab to main
        }
    }
}

extension PostVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //media is album , photo is picture. rmb to allow it in plist
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { //cancel button in photo
        isNewPost = true
        dismiss(animated: true, completion: nil)
        self.tabBarController?.selectedIndex = self.currentTabIndex

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.imageView.image = selectedImage
        self.doneButton.isEnabled = true
        
        dismiss(animated: true, completion: nil)
        
        
    }
}
