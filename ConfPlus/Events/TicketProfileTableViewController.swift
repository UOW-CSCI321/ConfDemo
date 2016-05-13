//
//  TicketProfileTableViewController.swift
//  confDemo
//
//  Created by Matthew Boroczky on 15/03/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import Foundation
import UIKit

class TicketProfileTableViewController: UITableViewController {
	
	@IBOutlet weak var qrImage: UIImageView!
	
	@IBOutlet weak var roomDetailLabel: UILabel!
	@IBOutlet weak var typeDetailLabel: UILabel!
	@IBOutlet weak var seatDetailLabel: UILabel!
	@IBOutlet weak var nameDetailLabel: UILabel!
	@IBOutlet weak var emailDetailLabel: UILabel!
	
	var ticket:Ticket_Record?
	
	let user = NSUserDefaults.standardUserDefaults()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		if ticket != nil{
			generateQR()
			roomDetailLabel.text = ticket?.room_name
			typeDetailLabel.text = ticket?.type
			seatDetailLabel.text = String(ticket?.seat_num)
			nameDetailLabel.text = user.stringForKey("firstName")
			emailDetailLabel.text = user.stringForKey("email")
			
		}
		
		
		navigationController?.hidesBarsOnSwipe = true
	}
	
	
	func generateQR(){
		
	}
}