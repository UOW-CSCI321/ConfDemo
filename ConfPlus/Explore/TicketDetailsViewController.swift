//
//  TicketDetailsViewController.swift
//  confDemo
//
//  Created by Matthew Boroczky on 15/03/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import MPGNotification
import PKHUD

struct Coupon {
	var ticket: [Tickets]
	var name: String
	var email: String
}

struct Tickets {
	var title:String?
	var price:String?
	var name:String?
	var _class:String?
	var type:String?
	var venue:String?
	var room:String?
	var seat:String?
	var startTime:NSDate?
	var endTime:NSDate?
	
}

class TicketDetailsViewController: UIViewController {
    
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var totalPrice: UITextField!
	
	// IBOutlet for the Selection View
	@IBOutlet weak var ticketSelectionView: UIView!
	@IBOutlet weak var ticketName: UILabel!
	@IBOutlet weak var ticketCount: UILabel!
	
	var event:Event!
	let user = NSUserDefaults.standardUserDefaults()
	
	var eventTickets = [Tickets]()
	var sessionTickets = [Tickets]()
	var selectedTickets = [Coupon]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		ticketSelectionView.hidden = true
		viewEffect.rect(ticketSelectionView)
		
		totalPrice.text = "0"
		
		HUD.show(.Progress)
		APIManager().getEventTickets(event.event_id!){ result, json in
			self.eventTickets.removeAll()
			if result{
				let dateFormatter = NSDateFormatter()
				dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
				dateFormatter.timeZone = NSTimeZone(name: "GMT")
				
				for i in 0 ..< json!["data"].count {
					let data = json!["data"][i]
					self.eventTickets.append(Tickets(title:	data["title"].string,
													price:	data["price"].string,
													name:	data["name"].string,
													_class: data["class"].string,
													type:	data["type"].string,
													venue:	data["venue"].string,
													room:	data["room"].string,
													seat:	data["seat_num"].string,
													startTime:	dateFormatter.dateFromString(data["start_date"].stringValue),
													endTime:	dateFormatter.dateFromString(data["end_date"].stringValue)))
				}
				print(self.eventTickets)
				HUD.hide()
				self.tableView.reloadData()
			} else {
				self.fetchError("No Tickets available!", message: "Contact Event Organizer for the ticket.")
			}
			
		}
    }
	
	@IBAction func performContinue(sender: AnyObject) {
		if shouldPerformSegueWithIdentifier("goToUserInfoView", sender: self){
			performSegueWithIdentifier("goToUserInfoView", sender: self)
		}
	}
	
	override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
		if identifier == "goToUserInfoView" {
			selectedTickets.removeAll()
			for section in 0..<tableView.numberOfSections{
				let cell:TicketTableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: section)) as! TicketTableViewCell
				for _ in 0..<Int(cell.ticketCount.text!)! {
					selectedTickets.append(Coupon(ticket: [eventTickets[section]], name: "", email: ""))
				}
			}
		}
		if selectedTickets.count > 0 {
			return true
		}
		HUD.show(.Label("Please select ticket to continue"))
		return false
	}

	func fetchError(title: String = "No internet Connection", message:String = "Data might not updated."){
		let notification = MPGNotification(title: title, subtitle: message, backgroundColor: UIColor.orangeColor(), iconImage: nil)
		notification.show()
	}
	
}

extension TicketDetailsViewController: UITableViewDelegate{
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return eventTickets.count
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("ticketCell", forIndexPath: indexPath) as! TicketTableViewCell
		
		let col = indexPath.section
		
		cell.ticketCount.text = "0"
		cell.ticketName.text = eventTickets[col].name
		cell.ticketPrice.text = eventTickets[col].price
		
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
			
			let vc = segue.destinationViewController as! PersonalDetailsViewController
			vc.tickets = selectedTickets
			vc.event = event
		}
	}
}

// MARK: Ticket Selection View Dialog related function
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
		
		self.totalPrice.text = String(Double(totalPrice.text!)! + Double(cell.ticketPrice.text!)!)
	}
	
	@IBAction func decreaseTicketInSelection(sender: AnyObject) {
		let section = tableView.indexPathForSelectedRow?.section
		let cell:TicketTableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: section!)) as! TicketTableViewCell
		
		if(Int(ticketCount.text!) > 0){
			self.ticketCount.text = String(Int(ticketCount.text!)! - 1)
			cell.ticketCount.text = self.ticketCount.text
			
			
			self.totalPrice.text = String(Double(totalPrice.text!)! - Double(cell.ticketPrice.text!)!)
		}
		
	}
	
	@IBAction func addTicketInSelection(sender: AnyObject) {
		ticketSelectionView.hidden = true
	}
}