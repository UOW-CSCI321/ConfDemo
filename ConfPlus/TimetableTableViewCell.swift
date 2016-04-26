//
//  TimetableTableViewCell.swift
//  ConfPlus
//
//  Created by CY Lim on 26/04/2016.
//  Copyright © 2016 Conf+. All rights reserved.
//

import UIKit

class TimetableTableViewCell: UITableViewCell {
	
	@IBOutlet weak var presentationName: UILabel!
	@IBOutlet weak var presentationTime: UILabel!
	@IBOutlet weak var presentationLocation: UILabel!
	@IBOutlet weak var presentationPrice: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
