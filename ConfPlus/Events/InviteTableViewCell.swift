//
//  InviteTableViewCell.swift
//  ConfPlus
//
//  Created by Matthew Boroczky on 7/06/2016.
//  Copyright © 2016 Conf+. All rights reserved.
//

//
//  MessageTableViewCell.swift
//  ConfPlus
//
//  Created by Matthew Boroczky on 11/05/2016.
//  Copyright © 2016 Conf+. All rights reserved.
//

import UIKit

class inviteTableViewCell: UITableViewCell {

    @IBOutlet weak var inviteImageView: UIImageView!
    
    @IBOutlet weak var inviteLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        usersName.font = UIFont.systemFontOfSize(18)
//        messageDescription.font = UIFont.systemFontOfSize(14)
//        messageDateLabel.font = UIFont.systemFontOfSize(16)
//        
//        messageDescription.textColor = UIColor.darkGrayColor()
//        messageDateLabel.textColor = UIColor.darkGrayColor()
        
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}