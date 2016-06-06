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
import Localize_Swift

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
	var endSales:String?
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
	
	var titles = [String]()
	var eventTickets = Dictionary<String, [Tickets]>()
	var sessionTickets = Dictionary<String, [Tickets]>()
	var selectedTickets = [Coupon]()
	
	func addToArray(data:JSON, inout array: Dictionary<String, [Tickets]>){
		let tickets = data["tickets"]
		for index in 0..<tickets.count {
			let info = tickets[index]
			if info != nil {
				let tit = Tickets(title: info["title"].string,
			                   price: info["price"].string,
			                   name: info["name"].string,
			                   _class: info["class"].string,
			                   type: info["type"].string,
			                   venue: data["venue_id"].string,
			                   room: data["room_name"].string,
			                   seat: nil,
			                   startTime: GeneralLibrary().getFullDate(data["start_time"].stringValue),
			                   endTime: GeneralLibrary().getFullDate(data["end_time"].stringValue),
			                   endSales: info["sale_end_date"].string,
			                   count: "0")
				
				if GeneralLibrary().getFullStringFromDate(NSDate()) <= tit.endSales || tit.endSales == nil {
					if array.indexForKey(tit.title!) == nil {
						array[tit.title!] = [tit]
					} else {
						array[tit.title!]!.append(tit)
					}
				}
			}
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
					if data["privacy"] == "public"{
						if data["is_event"] == "true" {
							self.addToArray(data, array: &self.eventTickets)
						} else {
							self.addToArray(data, array: &self.sessionTickets)
						}

					}
					self.titles = Array(self.eventTickets.keys)
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
				let itemSection = eventTickets[titles[section]]
				
				for row in 0..<tableView.numberOfRowsInSection(section) {
					let cell:TicketTableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: section)) as! TicketTableViewCell
					
					let item = itemSection![row]
					for _ in 0..<Int(cell.ticketCount.text!)!{
						selectedTickets.append(Coupon(ticket: [item], name: "", email: ""))
					}
				}
			}
		}
		if selectedTickets.count > 0 {
			return true
		}
		HUD.flash(.Label("selectTicket".localized()), delay: 1)
		return false
	}
}

extension TicketDetailsViewController: UITableViewDelegate{
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return titles.count
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return eventTickets[titles[section]]!.count
	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return titles[section]
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("ticketCell", forIndexPath: indexPath) as! TicketTableViewCell

		let row = indexPath.row
		let sec = indexPath.section
		
		let itemSection = eventTickets[titles[sec]]
		let item = itemSection![row]
		
		cell.ticketCount.text = item.count
		cell.ticketName.text = item.name
		cell.ticketPrice.text = item.price
		
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let section = indexPath.section
		let row = indexPath.row
		let cell:TicketTableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: section)) as! TicketTableViewCell
		
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
		let row = tableView.indexPathForSelectedRow?.row
		let cell:TicketTableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row!, inSection: section!)) as! TicketTableViewCell
		
		self.ticketCount.text = String(Int(ticketCount.text!)! + 1)
		cell.ticketCount.text = self.ticketCount.text
		//eventTickets[titles[section!]]!.count = cell.ticketCount.text
		
		self.totalPrice.text = String(Double(totalPrice.text!)! + Double(cell.ticketPrice.text!)!)
	}
	
	@IBAction func decreaseTicketInSelection(sender: AnyObject) {
		let section = tableView.indexPathForSelectedRow?.section
		let row = tableView.indexPathForSelectedRow?.row
		let cell:TicketTableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row!, inSection: section!)) as! TicketTableViewCell
		
		if(Int(ticketCount.text!) > 0){
			self.ticketCount.text = String(Int(ticketCount.text!)! - 1)
			cell.ticketCount.text = self.ticketCount.text
			//eventTickets[titles[section!]]!.count = cell.ticketCount.text
			
			
			self.totalPrice.text = String(Double(totalPrice.text!)! - Double(cell.ticketPrice.text!)!)
		}
		
	}
	
	@IBAction func addTicketInSelection(sender: AnyObject) {
		ticketSelectionView.hidden = true
	}
}