//
//  PersonalDetailsViewController.swift
//  confDemo
//
//  Created by Matthew Boroczky on 15/03/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import UIKit
import PKHUD

class PersonalDetailsViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	
	var tickets = [Coupon]()
	var event:Event!
	var sessionTickets = [Tickets]()
	let type = ["Name", "Email"]
	
	let user = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	@IBAction func performContinue(sender: AnyObject) {
		if self.shouldPerformSegueWithIdentifier("goToConfirmation", sender: nil){
			self.performSegueWithIdentifier("goToConfirmation", sender: nil)
		}
	}
	
	override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
		if identifier == "goToConfirmation" {
			for section in 0..<tableView.numberOfSections{
				for row in 0..<tableView.numberOfRowsInSection(section){
					let cell:PersonalDetailsTableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: section)) as! PersonalDetailsTableViewCell
					
					let detail = cell.typeResponseTextField.text
					if detail == "" {
						HUD.flash(.Label("Fields must not be empty"), delay: 1)
						return false
					}
					
					let info = cell.detailType.text
					if info == "Name" {
						tickets[section].name = detail!
					} else if info == "Email" {
						tickets[section].email = detail!
					}
					
				}
			}
			return true
		}
		
		return false
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "goToConfirmation" {
			let vc = segue.destinationViewController as! PaymentViewController
			vc.sessionTickets = sessionTickets
			vc.tickets = tickets
			vc.event = event
		}
	}
	
}

extension PersonalDetailsViewController: UITableViewDelegate {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return tickets.count
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return type.count
	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return tickets[section].ticket[0].name
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("personalCell", forIndexPath: indexPath) as! PersonalDetailsTableViewCell
		
		let row = indexPath.row
		cell.detailType.text = type[row]
		cell.typeResponseTextField.placeholder = type[row]
		
		if indexPath.section == 0 {
			if let email = user.stringForKey("email"), name = user.stringForKey("firstName") {
				if cell.typeResponseTextField.placeholder == "Name" && cell.typeResponseTextField.text != nil {
					cell.typeResponseTextField.text = name
				} else if cell.typeResponseTextField.placeholder == "Email" && cell.typeResponseTextField.text != nil {
					cell.typeResponseTextField.text = email
				}
			}
		}
		
		return cell
	}
	
}