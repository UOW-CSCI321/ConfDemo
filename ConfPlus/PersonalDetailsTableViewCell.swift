//
//  PersonalDetailsTableViewCell.swift
//  ConfPlus
//
//  Created by CY Lim on 26/04/2016.
//  Copyright © 2016 Conf+. All rights reserved.
//

import UIKit

class PersonalDetailsTableViewCell: UITableViewCell {

	@IBOutlet weak var detailType: UILabel!
	@IBOutlet weak var typeResponseTextField: UITextField!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
