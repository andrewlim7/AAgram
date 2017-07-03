//
//  SelectedImageVC.swift
//  AAgram
//
//  Created by Mohd Adam on 27/06/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit

class SelectedImageVC: UIViewController {
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var selectedImgView: UIImageView!
    @IBOutlet weak var selectedProfPic: UIImageView!
    @IBOutlet weak var numberOfLikes: UILabel!
    
    
    var selectedName: String = ""
    var selectedCaption: String = ""
    var selectedImg: UIImage!
    var selectedProfileImage : UIImage?
    
    static let CellIdentifer = "SelectedImageVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        usernameLabel.text = selectedName
        captionTextView.text = selectedCaption
        selectedImgView.image = selectedImg
        selectedProfPic.image = selectedProfileImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func exitBtnPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func likeBtnPressed(_ sender: Any) {
    }

}
