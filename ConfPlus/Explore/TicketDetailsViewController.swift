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
	@IBOutlet weak var totalPrice: UITextField!
	
	// IBOutlet for the Selection View
	@IBOutlet weak var ticketSelectionView: UIView!
	@IBOutlet weak var ticketName: UILabel!
	@IBOutlet weak var ticketCount: UILabel!
	
	
	let user = NSUserDefaults.standardUserDefaults()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		ticketSelectionView.hidden = true
		viewEffect.rect(ticketSelectionView)
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(true)
		
		guard let _ = user.stringForKey("email") else {
			performLogin()
			return
		}
	}
	
	func performLogin(){
		let storyboard : UIStoryboard = UIStoryboard(name: "Account", bundle: nil)
		let vc : LoginViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
		
		let navigationController = UINavigationController(rootViewController: vc)
		
		self.presentViewController(navigationController, animated: true, completion: nil)
	}
	
}

extension TicketDetailsViewController: UITableViewDelegate{
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("ticketCell", forIndexPath: indexPath) as! TicketTableViewCell
		
		cell.ticketCount.text = "0"
		cell.ticketName.text = "Ticket Name -\(indexPath.section)"
		cell.ticketPrice.text = "1"
		
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let section = indexPath.section
		let cell:TicketTableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: section)) as! TicketTableViewCell
		
		self.ticketCount.text = cell.ticketCount.text
		self.ticketName.text = cell.ticketName.text
		
		showticketSelectionView()
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "goToUserInfoView"{
			var ticketName = [String]()
			var totalTicket = 0
			let totalTicketType = tableView.numberOfSections
			for section in 0..<totalTicketType{
				let cell:TicketTableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: section)) as! TicketTableViewCell
				totalTicket += Int(cell.ticketCount.text!)!
				ticketName.append(cell.ticketName.text!)
			}
			
			let vc = segue.destinationViewController as! PersonalDetailsViewController
			vc.TOTAL_TICKET_QUANTITY = totalTicket
			vc.ticketName = ticketName
		}
	}
}

// MARK: Ticket Selection View related function
extension TicketDetailsViewController {
	
	func showticketSelectionView(){
		ticketSelectionView.hidden = false
	}
	
	// Button Action for the Selection View
	@IBAction func increaseTicketInSelection(sender: AnyObject) {
		let section = tableView.indexPathForSelectedRow?.section
		let cell:TicketTableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: section!)) as! TicketTableViewCell
		
		self.ticketCount.text = String(Int(ticketCount.text!)! + 1)
		cell.ticketCount.text = self.ticketCount.text
		
		self.totalPrice.text = String(Int(totalPrice.text!)! + Int(cell.ticketPrice.text!)!)
	}
	
	@IBAction func decreaseTicketInSelection(sender: AnyObject) {
		let section = tableView.indexPathForSelectedRow?.section
		let cell:TicketTableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: section!)) as! TicketTableViewCell
		
		if(Int(ticketCount.text!) > 0){
			self.ticketCount.text = String(Int(ticketCount.text!)! - 1)
			cell.ticketCount.text = self.ticketCount.text
			
			self.totalPrice.text = String(Int(totalPrice.text!)! - Int(cell.ticketPrice.text!)!)
		}
		
	}
	
	@IBAction func addTicketInSelection(sender: AnyObject) {
		ticketSelectionView.hidden = true
	}
}