//
//  ExploreTableViewCell.swift
//  ConfPlus
//
//  Created by CY Lim on 19/03/2016.
//  Copyright © 2016 Conf+. All rights reserved.
//

import UIKit

class ExploreTableViewCell: UITableViewCell {
	
	
	@IBOutlet weak var eventCell: UIView!
	
	@IBOutlet weak var eventImage: UIImageView!
	@IBOutlet weak var eventName: UILabel!
	@IBOutlet weak var eventDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		viewEffect.rect(eventCell)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
