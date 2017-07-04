//
//  EditProfileVC.swift
//  AAgram
//
//  Created by Andrew Lim on 23/06/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class EditProfileVC: UIViewController, UITextFieldDelegate {


    @IBOutlet weak var changeImageView: UIImageView!
    
    @IBOutlet weak var bioTextField: UITextField!{
        didSet{
            bioTextField.delegate = self
        }
    }
    
    @IBOutlet weak var changeProfilePicButton: UIButton!{
        didSet{
            changeProfilePicButton.addTarget(self, action: #selector(didTapChangeProficPicButton(_:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var doneButton: UIButton! {
        didSet{
            doneButton.addTarget(self, action: #selector(didTapDoneButton(_:)), for: .touchUpInside)
            //doneButton.isEnabled = false
        }
    }
    
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    var isImageSelected : Bool = false
    var getBio : String?
    var getProfileImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bioTextField.text = getBio
        self.changeImageView.image = getProfileImage
        setupSpinner()
        myActivityIndicator.color = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        myActivityIndicator.backgroundColor = UIColor.gray

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didTapChangeProficPicButton (_ sender: Any){
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
        
    }

    func didTapDoneButton(_ sender : Any){
        self.myActivityIndicator.startAnimating()
        
            guard
                let uid = Auth.auth().currentUser?.uid,
                let changeBio = self.bioTextField.text
            else {return}
            
            let storageRef = Storage.storage().reference()
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            
            let data = UIImageJPEGRepresentation(self.changeImageView.image!, 0.8)
            
            storageRef.child("\(uid).jpg").putData(data!, metadata: metadata) { (newMeta, error) in
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
                    
                    let param : [String : Any] = ["profileImageURL": imageURL,
                                                  "bio": changeBio]
                    
                    let ref = Database.database().reference().child("users")
                    ref.child(uid).updateChildValues(param)
                    
                    
                    self.myActivityIndicator.stopAnimating()
                    self.navigationController?.popViewController(animated: true)
                }
            }


    }
    
    func setupSpinner(){
        // Position Activity Indicator in the center of the main view
        myActivityIndicator.center = view.center
        
        // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
        myActivityIndicator.hidesWhenStopped = true
        
        view.addSubview(myActivityIndicator)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        bioTextField.resignFirstResponder()
        return true
    }

}

extension EditProfileVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //media is album , photo is picture. rmb to allow it in plist
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { //cancel button in photo
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.changeImageView.image = selectedImage
        
        //self.isImageSelected = true
        //self.doneButton.isEnabled = true
        
        dismiss(animated: true, completion: nil)
        
        
    }
}

