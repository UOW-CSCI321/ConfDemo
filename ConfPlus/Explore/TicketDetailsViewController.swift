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
	var ticket: [Sessions]
	var name: String
	var email: String
}

struct Sessions {
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
	var conversation:String?
	var count:String?
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
	
	var eventTickets = [Sessions]()
	var sessionTickets = [Sessions]()
	var selectedTickets = [Coupon]()
	
	func addToArray(data:JSON, inout array: [Sessions]){
		let ticket = data["tickets"][0]
		if ticket != nil {
			array.append(Sessions(title: data["title"].string,
				price: ticket["price"].string,
				name: ticket["name"].string,
				_class: ticket["class"].string,
				type: ticket["type"].string,
				venue: data["venue_id"].string,
				room: data["room_name"].string,
				seat: nil,
				startTime: GeneralLibrary().getFullDate(data["start_time"].stringValue),
				endTime: GeneralLibrary().getFullDate(data["end_time"].stringValue),
				conversation: data["conversation_id"].string,
				count: "0"))
		}
		
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		ticketSelectionView.hidden = true
		viewEffect.rect(ticketSelectionView)
		
		totalPrice.text = "0"
		
		HUD.show(.Progress)
		APIManager().getEventTickets(event.event_id!){ result, json in
			self.eventTickets.removeAll()
			self.sessionTickets.removeAll()
			
			if result{
				for i in 0 ..< json!["data"].count {
					let data = json!["data"][i]
					print(data)
					if data["is_event"] == "true" {
						self.addToArray(data, array: &self.eventTickets)
					} else {
						self.addToArray(data, array: &self.sessionTickets)
					}
				}
				
				HUD.hide()
				self.tableView.reloadData()
			} else {
				GeneralLibrary().fetchError("No Tickets available!", message: "Contact Event Organizer for the ticket.")
			}
		}
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		
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
				for _ in 0..<Int(eventTickets[section].count!)! {
					selectedTickets.append(Coupon(ticket: [eventTickets[section]], name: "", email: ""))
				}
			}
		}
		if selectedTickets.count > 0 {
			return true
		}
		HUD.flash(.Label("Please select ticket to continue"), delay: 1)
		return false
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
		
		cell.ticketCount.text = eventTickets[col].count
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
			vc.sessionTickets = sessionTickets
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
		eventTickets[section!].count = cell.ticketCount.text
		
		self.totalPrice.text = String(Double(totalPrice.text!)! + Double(cell.ticketPrice.text!)!)
	}
	
	@IBAction func decreaseTicketInSelection(sender: AnyObject) {
		let section = tableView.indexPathForSelectedRow?.section
		let cell:TicketTableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: section!)) as! TicketTableViewCell
		
		if(Int(ticketCount.text!) > 0){
			self.ticketCount.text = String(Int(ticketCount.text!)! - 1)
			cell.ticketCount.text = self.ticketCount.text
			eventTickets[section!].count = cell.ticketCount.text
			
			
			self.totalPrice.text = String(Double(totalPrice.text!)! - Double(cell.ticketPrice.text!)!)
		}
		
	}
	
	@IBAction func addTicketInSelection(sender: AnyObject) {
		ticketSelectionView.hidden = true
	}
}