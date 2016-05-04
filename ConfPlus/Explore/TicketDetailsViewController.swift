//
//  TicketDetailsViewController.swift
//  confDemo
//
//  Created by Matthew Boroczky on 15/03/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import Foundation
import UIKit

class TicketDetailsViewController: UIViewController {
    
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var totalPrice: UIBarButtonItem!
	
	@IBAction func cancelPurchaseTicket(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension TicketDetailsViewController: UITableViewDelegate{
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("ticketCell", forIndexPath: indexPath) as! TicketTableViewCell
		
		cell.ticketCount.text = "0"
		cell.ticketName.text = "Ticket Name"
		cell.ticketPrice.text = "AUD 1.00"
		
		return cell
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "goToUserInfoView"{
			var totalTicket = 0
			let totalTicketType = tableView.numberOfRowsInSection(0)
			for row in 0..<totalTicketType{
				let cell:TicketTableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as! TicketTableViewCell
				totalTicket += Int(cell.ticketCount.text!)!
			}
			
			let vc = segue.destinationViewController as! PersonalDetailsViewController
			vc.TOTAL_TICKET_QUANTITY = totalTicket
		}
	}
}