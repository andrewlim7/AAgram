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

class RegisterVC: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField! {
        didSet{
            usernameTextField.placeholder = "Insert Username"
        }
    }
    
    @IBOutlet weak var emailTextField: UITextField! {
        didSet{
            emailTextField.placeholder = "Insert Email"
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet{
            passwordTextField.isSecureTextEntry = true
        }
    }
    
    @IBOutlet weak var confirmPasswordTextField: UITextField! {
        didSet{
            confirmPasswordTextField.isSecureTextEntry = true
        }
    }
    
    @IBOutlet weak var signUpButton: UIButton! {
        didSet{
            signUpButton.addTarget(self, action: #selector(didTapSignUpButton(_:)), for: .touchUpInside)
        }
    }
    
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)

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
    
    func didTapSignUpButton(_ sender: Any){
        self.myActivityIndicator.startAnimating()
        
        guard
            let username = usernameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text
        else { return; }
        
        if username == "" {
            self.usernameAlert()
            
        } else if password == "" {
            self.passwordAlert()
            
        } else if password.characters.count < 6  {
            self.lessPasswordAlert()
            
        } else if email == "" {
            self.emailAlert()
            
        } else if password != confirmPassword {
            self.passwordDifferentAlert()
            
        } else {
            
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if let validError = error {
                    print(validError.localizedDescription)
                    return;
                }
                
                let uid = Auth.auth().currentUser?.uid
                
                let param : [String : Any] = ["username": username,
                                              "email": email]
                
                let ref = Database.database().reference()
                ref.child(uid!).setValue(param)
                
                try? Auth.auth().signOut()
                
                self.navigationController?.popViewController(animated: true)
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
    
    func usernameAlert() {
        let alertController = UIAlertController(title: "Error", message: "Please enter your username", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(ok)
        
        present(alertController, animated: true, completion: nil)
        self.myActivityIndicator.stopAnimating()
    }
    
    func emailAlert() {
        let alertController = UIAlertController(title: "Error", message: "Please enter your email", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(ok)
        
        present(alertController, animated: true, completion: nil)
        self.myActivityIndicator.stopAnimating()
    }
    
    func passwordAlert() {
        let alertController = UIAlertController(title: "Error", message: "Please enter your password", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(ok)
        
        present(alertController, animated: true, completion: nil)
        self.myActivityIndicator.stopAnimating()
    }
    
    func lessPasswordAlert() {
        let alertController = UIAlertController(title: "Error", message: "Please enter minimum of 6 characters for password", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(ok)
        
        present(alertController, animated: true, completion: nil)
        self.myActivityIndicator.stopAnimating()
    }
    
    func existEmailAlert() {
        let alertController = UIAlertController(title: "Error", message: "Please enter another email address!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(ok)
        
        present(alertController, animated: true, completion: nil)
        self.myActivityIndicator.stopAnimating()
    }
    
    func passwordDifferentAlert() {
        let alertController = UIAlertController(title: "Error", message: "Please enter your password and confrim password correctly!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(ok)
        
        present(alertController, animated: true, completion: nil)
        self.myActivityIndicator.stopAnimating()
    }
}
