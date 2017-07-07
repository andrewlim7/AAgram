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
import Fusuma

class PostVC: UIViewController,UITabBarControllerDelegate, FusumaDelegate, UITextViewDelegate {

    @IBOutlet weak var cancelButton: UIButton!{
        didSet{
            cancelButton.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
    
    @IBOutlet weak var doneButton: UIButton!{
        didSet{
            doneButton.addTarget(self, action: #selector(doneButtonTapped(_:)), for: .touchUpInside)
            doneButton.isEnabled = false
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var textView: UITextView! {
        didSet{
            textView.text = ""
        }
    }
    
    var isNewPost : Bool = true
    var isReEditPost : Bool = false
    
    var getUsername : String = ""
    var currentTabIndex : Int = 0
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsernameFromDB()
        getFBNameFromDB()
        setupSpinner()
        
        myActivityIndicator.color = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        myActivityIndicator.backgroundColor = UIColor.gray
        
        imageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(sender:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tapGestureRecognizer)

    }
    
    func imageTapped(sender: UITapGestureRecognizer) {
        if isNewPost == false {
            let fusuma = FusumaViewController()
            fusuma.delegate = self
            self.present(fusuma, animated: true, completion:nil)
            
            //isNewPost = true // this cause the whole problem, will present twice
            doneButton.isEnabled = true
            isReEditPost = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        textView.resignFirstResponder()
        
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.view.frame.origin.y == 0 {
                
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.view.frame.origin.y != 0 {
                
                self.view.frame.origin.y += keyboardSize.height
            }
        }
        
    }
    
    func cancelButtonTapped(_ sender:Any){
        print("closed")
        isNewPost = true
        imageView.image = nil
        dismiss(animated: true, completion: nil)
        self.tabBarController?.selectedIndex = self.currentTabIndex
    }
    
    override func viewWillAppear(_ animated: Bool) {
        imageView.image = nil
        if isNewPost == true {
//            let pickerController = UIImagePickerController()
//            pickerController.delegate = self
//            present(pickerController, animated: true, completion: nil)
            
            let fusuma = FusumaViewController()
            fusuma.delegate = self
            //fusuma.hasVideo = true // If you want to let the users allow to use video.
            self.present(fusuma, animated: true, completion:nil)
            
            isNewPost = false
            doneButton.isEnabled = true
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.textView.delegate = self

    }
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        imageView.image = image
        
        isReEditPost = false

    }
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        
    }
    
    func fusumaCameraRollUnauthorized() {
        
    }
    

    func fusumaWillClosed() {
        print("Will close")
        if isReEditPost == true {
            dismiss(animated: true, completion: nil)
            isReEditPost = false
        } else {
            print("closed")
            isNewPost = true
            imageView.image = nil
            self.tabBarController?.selectedIndex = self.currentTabIndex
            dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    func fusumaClosed() {

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
        imageView.image = nil
        
    }
    
    func dismissButtonTapped(_ sender: Any){
        
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        self.present(fusuma, animated: true, completion:nil)
    }
    
    func doneButtonTapped(_ sender: Any){
        self.myActivityIndicator.startAnimating()
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
            self.myActivityIndicator.stopAnimating()
        }
    }
    
    func setupSpinner(){
        // Position Activity Indicator in the center of the main view
        myActivityIndicator.center = view.center
        
        // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
        myActivityIndicator.hidesWhenStopped = true
        
        view.addSubview(myActivityIndicator)
    }
}

//extension PostVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    
//    //media is album , photo is picture. rmb to allow it in plist
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { //cancel button in photo
//        isNewPost = true
//        dismiss(animated: true, completion: nil)
//        self.tabBarController?.selectedIndex = self.currentTabIndex
//
//    }
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        
//        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
//        
//        self.imageView.image = selectedImage
//        self.doneButton.isEnabled = true
//        
//        dismiss(animated: true, completion: nil)
//        
//        
//    }
//}
