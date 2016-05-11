//
//  MessageTableViewCell.swift
//  ConfPlus
//
//  Created by Matthew Boroczky on 11/05/2016.
//  Copyright © 2016 Conf+. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var usersName: UILabel!
    @IBOutlet var messageDescription: UILabel!
    @IBOutlet var messageDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
