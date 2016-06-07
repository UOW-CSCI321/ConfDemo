//
//  SessionTicketsTableViewCell.swift
//  ConfPlus
//
//  Created by CY Lim on 2/06/2016.
//  Copyright © 2016 Conf+. All rights reserved.
//

import UIKit

protocol CellDelegate {
	func cellClicked(cell:UITableViewCell)
}

class SessionTicketsTableViewCell: UITableViewCell {
	
	@IBOutlet weak var presentationName: UILabel!
	@IBOutlet weak var presentationTime: UILabel!
	@IBOutlet weak var presentationLocation: UILabel!
	var delegate:CellDelegate?
	
	@IBAction func selectedSessionTicket(sender: AnyObject) {
		if let del = delegate {
			del.cellClicked(self)
		}
		
//		if self.backgroundColor == UIColor.clearColor() {
//			self.backgroundColor = UIColor.init(red: 0, green: 0.8, blue: 0, alpha: 0.2)
//		} else {
//			self.backgroundColor = UIColor.clearColor()
//		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
}