//
//  addSessionTicketTableViewCell.swift
//  ConfPlus
//
//  Created by CY Lim on 6/06/2016.
//  Copyright © 2016 Conf+. All rights reserved.
//

import UIKit

class AddSessionTicketTableViewCell: UITableViewCell {

	@IBOutlet weak var name: UILabel!
	@IBOutlet weak var _class: UILabel!
	@IBOutlet weak var type: UILabel!
	@IBOutlet weak var price: UILabel!
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
