//
//  TimeTableViewController.swift
//  confDemo
//
//  Created by CY Lim on 15/03/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import Foundation
import UIKit

class SessionTicketsViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	
	var sessionTickets = [Tickets]()
	var ticket:Coupon!
	var event:Event!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		print(event)
		print(ticket)
	}
	
}

extension SessionTicketsViewController: UITableViewDelegate{
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 3
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Date-\(section)"
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("presentationCell", forIndexPath: indexPath) as! TimetableTableViewCell
		
		cell.backgroundColor = UIColor.clearColor()
		//if cell.presentationName.text ==
		
		cell.presentationName.text = "Presentation Name"
		cell.presentationTime.text = "HH:MM - HH:MM"
		cell.presentationLocation.text = "Building 1, Room 1"
		cell.presentationPrice.text = "AUD 1.00"
		
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		//self.performSegueWithIdentifier("goToPresentationDetailView", sender: self)
	}
}