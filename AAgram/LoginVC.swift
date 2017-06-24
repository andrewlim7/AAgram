 //
//  LoginVC.swift
//  AAgram
//
//  Created by Andrew Lim on 23/06/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class LoginVC: UIViewController,FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var emailTextField: UITextField! {
        didSet{
           emailTextField.placeholder = "Insert email address"
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet{
            passwordTextField.placeholder = "Insert password"
            passwordTextField.isSecureTextEntry = true
        }
    }
    
    @IBOutlet weak var emailLoginButton: UIButton! {
        didSet{
            emailLoginButton.addTarget(self, action: #selector(didTapLoginButton(_:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton! {
        didSet{
            fbLoginButton.delegate = self
        }
    }
    
    
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        setupSpinner()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
            print("HELLOOOOOOOOOOOOOOO")
        if let error = error {
            print(error.localizedDescription)
            self.fbAlert()
            return
        } else if (result.isCancelled == true) {
            print("ERROR")

        } else {
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            Auth.auth().signIn(with: credential) { (user, error) in
                // put all the user detail 
   
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let mainVC = storyboard.instantiateViewController(withIdentifier: "FeedVC") as! FeedVC
            self.present(mainVC, animated: true, completion: nil)
        }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("FB logout successfully!")
    }
    
    func didTapLoginButton(_ sender: Any){
        self.myActivityIndicator.startAnimating()
        
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
            else {
                return;
        }
        
        if emailTextField.text == "" {
            self.emailAlert()
            
        } else if password == "" || password.characters.count < 6 {
            self.passwordAlert()
            
        } else {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if let validError = error {
                    print(validError.localizedDescription)
                    self.emailInvalidAlert()
                    return;
                }
                
                
                print("User exist \(user?.uid ?? "")")
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let mainVC = storyboard.instantiateViewController(withIdentifier: "FeedVC")
                self.present(mainVC, animated: true, completion: nil)
                self.myActivityIndicator.stopAnimating()
                self.emailTextField.text = nil
                self.passwordTextField.text = nil
            }
        }
        
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Auth", bundle: Bundle.main)
        let registerVC = storyboard.instantiateViewController(withIdentifier: "RegisterVC")
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    func setupSpinner(){
        // Position Activity Indicator in the center of the main view
        myActivityIndicator.center = view.center
        
        // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
        myActivityIndicator.hidesWhenStopped = true
        
        view.addSubview(myActivityIndicator)
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
    
    func emailInvalidAlert() {
        let alertController = UIAlertController(title: "Error", message: "Please enter your email or password correctly!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(ok)
        
        present(alertController, animated: true, completion: nil)
        self.myActivityIndicator.stopAnimating()
    }
    
    func fbAlert(){
        let alertController = UIAlertController(title: "Login Error", message: "Please try again", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
    }

}
