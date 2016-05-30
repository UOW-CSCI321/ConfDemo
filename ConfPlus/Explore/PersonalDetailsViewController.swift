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
	let type = ["Name", "Email"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
    }
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "goToConfirmtion" {
			for section in 0..<tableView.numberOfSections{
				for row in 0..<tableView.numberOfRowsInSection(section){
					let cell:PersonalDetailsTableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: section)) as! PersonalDetailsTableViewCell
					if cell.detailType.text == "Name" {
						guard let name = cell.typeResponseTextField.text else {
							HUD.show(.Label("Name must not be empty"))
							return
						}
						tickets[section].name = name
					} else if cell.detailType.text == "Email" {
						guard let email = cell.typeResponseTextField.text else {
							HUD.show(.Label("Email must not be empty"))
							return
						}
						tickets[section].email = email
					}
					
				}
			}
			
			let vc = segue.destinationViewController as! PaymentViewController
			vc.tickets = tickets
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
		
		cell.detailType.text = type[indexPath.row]
		cell.typeResponseTextField.placeholder = type[indexPath.row]
		
		return cell
	}
	
}