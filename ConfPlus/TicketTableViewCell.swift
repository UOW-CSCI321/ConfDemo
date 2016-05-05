//
//  TicketTableViewCell.swift
//  ConfPlus
//
//  Created by CY Lim on 26/04/2016.
//  Copyright © 2016 Conf+. All rights reserved.
//

import UIKit

class TicketTableViewCell: UITableViewCell {

	@IBOutlet weak var ticketCount: UILabel!
	@IBOutlet weak var ticketName: UILabel!
	@IBOutlet weak var ticketPrice: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
