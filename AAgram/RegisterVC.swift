//
//  RegisterVC.swift
//  AAgram
//
//  Created by Andrew Lim on 23/06/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class RegisterVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField! {
        didSet{
            usernameTextField.placeholder = "Insert Username"
            usernameTextField.delegate = self
        }
    }
    
    @IBOutlet weak var emailTextField: UITextField! {
        didSet{
            emailTextField.placeholder = "Insert Email"
            emailTextField.delegate = self
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet{
            passwordTextField.isSecureTextEntry = true
            passwordTextField.delegate = self
        }
    }
    
    @IBOutlet weak var confirmPasswordTextField: UITextField! {
        didSet{
            confirmPasswordTextField.isSecureTextEntry = true
            confirmPasswordTextField.delegate = self
        }
    }
    
    @IBOutlet weak var signUpButton: UIButton! {
        didSet{
            signUpButton.addTarget(self, action: #selector(didTapSignUpButton(_:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var selectProfileButton: UIButton! {
        didSet{
            selectProfileButton.addTarget(self, action: #selector(tapSelectProfileButton(_:)), for: .touchUpInside)
        }
    }
    
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    var isImageSelected : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSpinner()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.title = "Registration"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    func tapSelectProfileButton(_ sender : Any){
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
        
    }
    
    func didTapSignUpButton(_ sender: Any){
        self.myActivityIndicator.startAnimating()
        
        guard
            let username = usernameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text
        else { return; }
        
        if username == "" {
            self.warningAlert(warningMessage: "Please enter your username")
            
        } else if password == "" {
            self.warningAlert(warningMessage: "Please enter your password")
            
        } else if password.characters.count < 6  {
            self.warningAlert(warningMessage: "Please enter minimum of 6 characters for password")
            
        } else if email == "" {
            self.warningAlert(warningMessage: "Please enter your email")
            
        } else if password != confirmPassword {
            self.warningAlert(warningMessage: "Please enter your password and confrim password correctly!")
            
        } else if isImageSelected == false {
            self.warningAlert(warningMessage: "Please select profile picture!")
            
        } else {
            
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if let validError = error {
                    print(validError.localizedDescription)
                    self.warningAlert(warningMessage: "Please enter another email address!")
                    return;
                }
                
                guard let uid = Auth.auth().currentUser?.uid else {return}
                
                let storageRef = Storage.storage().reference()
                
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpg"
                
                let data = UIImageJPEGRepresentation(self.imageView.image!, 0.8)
                
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
                        
                        let param : [String : Any] = ["username": username,
                                                      "email": email,
                                                      "profileURL": imageURL]
                        
                        let ref = Database.database().reference().child("users")
                        ref.child(uid).setValue(param)
                    }
                }
                
                //try? Auth.auth().signOut()
                
                //self.navigationController?.popViewController(animated: true)
                self.myActivityIndicator.stopAnimating()
                
                print("User sign-up successfully! \(user?.uid ?? "")")
                print("User email address! \(user?.email ?? "")")
                print("Username is \(username)")
                
            })
        }
    }
    
    func setupSpinner(){
        // Position Activity Indicator in the center of the main view
        myActivityIndicator.center = view.center
        
        // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
        myActivityIndicator.hidesWhenStopped = true
        
        view.addSubview(myActivityIndicator)
    }

    func warningAlert(warningMessage: String){
        let alertController = UIAlertController(title: "Error", message: warningMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(ok)
        
        present(alertController, animated: true, completion: nil)
        self.myActivityIndicator.stopAnimating()
        
    }
}

extension RegisterVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //media is album , photo is picture. rmb to allow it in plist
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { //cancel button in photo
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage

        self.imageView.image = selectedImage
        
        self.isImageSelected = true

        dismiss(animated: true, completion: nil)


    }
}
