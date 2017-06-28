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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
//        let navigationController = UINavigationController(rootViewController: UIViewController) as! FeedVC
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tarBarIndex = tabBarController.selectedIndex
        if tarBarIndex == 3 {
            //insert image picker view
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            present(pickerController, animated: true, completion: nil)
            print("TEST")
        }
    }
}

extension PostVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //media is album , photo is picture. rmb to allow it in plist
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { //cancel button in photo
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //rmb to check UIImagePickerControllerMedia type for video because right now only accept image.
        
//        let storageRef = Storage.storage().reference()
//        
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/jpg"
//        
//        guard let data = UIImageJPEGRepresentation(selectedImage, 0.8) else {
//            dismiss(animated: true, completion: nil)
//            return
//        }
//        
//        storageRef.child("1.jpg").putData(data, metadata: metadata) { (newMeta, error) in
//            if (error != nil) {
//                // Uh-oh, an error occurred!
//                print(error!)
//            } else {
//            
//                defer{
//                    self.dismiss(animated: true, completion: nil) //so the return function will return this
//                }
//                
//                if let foundError = error {
//                    print(foundError.localizedDescription)
//                    return
//                }
//                
//                guard let imageURL = newMeta?.downloadURLs?.first?.absoluteString else {
//                    return
//                }
//                
//                //method 2 directly download from URL which is using extension
//                self.sendTextMessage(imageURL: imageURL)
//            }
//        }
        
    }
}
