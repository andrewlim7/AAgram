//
//  CommentVC.swift
//  AAgram
//
//  Created by Andrew Lim on 29/06/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit

class CommentVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet{
            tableView.dataSource = self
            tableView.register(CommentCell.cellNib, forCellReuseIdentifier: CommentCell.CellIdentifier)
            
        }
    }
    @IBOutlet weak var textField: UITextField!

    @IBOutlet weak var postButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}

extension CommentVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let currentRow = indexPath.row
        
        let commentCell : CommentCell = tableView.dequeueReusableCell(withIdentifier: CommentCell.CellIdentifier, for: indexPath) as! CommentCell
        
        commentCell.textView.text = "HELLO"
        commentCell.timeLabel.text = "12.15pm"
        
        return commentCell
    }
    
}
