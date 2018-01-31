//
//  customMessageCell.swift
//  Chat App
//
//  Created by Mohamed on 1/12/18.
//  Copyright © 2018 Mohamed. All rights reserved.
//

import UIKit

class customMessageCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var messageBackground: UIView!
    @IBOutlet weak var senderUserName: UILabel!
    @IBOutlet weak var messageBody: UILabel!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

 
    
}
