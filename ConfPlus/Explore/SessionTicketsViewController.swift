//
//  TimeTableViewController.swift
//  confDemo
//
//  Created by CY Lim on 15/03/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import Foundation
import UIKit
import PKHUD

protocol selectSessionTicketDelegate{
	func selectSessionTicketDidFinish(controller:SessionTicketsViewController, email:String, session:[Tickets])
}

class SessionTicketsViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	
	var sessionTickets = [Tickets]()
	var ticket:Coupon!
	var event:Event!
	
	var dataSortedByDates = Dictionary<String, [Tickets]>()
	var dates = [String]()
	
	var delegate:selectSessionTicketDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		setDataForPresent()
	}
	
	@IBAction func updateSessionTickets(sender: AnyObject) {
		if let del = delegate {
			var sessions:[Tickets]!
			for section in 0..<tableView.numberOfSections{
				for row in 0..<tableView.numberOfRowsInSection(section){
					let cell:SessionTicketsTableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: section)) as! SessionTicketsTableViewCell
					
					if cell.backgroundColor == UIColor.init(red: 0, green: 0.8, blue: 0, alpha: 0.2) {
						let itemSection = dataSortedByDates[dates[section]]
						let item = itemSection![row]
						
						sessions.append(item)
					}
				}
			}
			
			
			if sessions!.count > 0 {
				del.selectSessionTicketDidFinish(self, email: ticket.email, session: sessions!)
			} else {
				navigationController?.popViewControllerAnimated(true)
			}
		}
	}
	
	func setDataForPresent(){
		dates.removeAll()
		dataSortedByDates.removeAll()
		
		HUD.show(.Progress)
		for session in sessionTickets  {
			let date = GeneralLibrary().getStringFromDate(session.startTime!)
			
			if self.dataSortedByDates.indexForKey(date) == nil {
				self.dataSortedByDates[date] = [session]
			} else {
				self.dataSortedByDates[date]!.append(session)
			}
			
			self.dataSortedByDates[date]?.sortInPlace({ $0.startTime!.compare($1.startTime!) == NSComparisonResult.OrderedAscending })
		}
		dates = Array(dataSortedByDates.keys).sort(<)
		
		if GeneralLibrary().getStringFromDate(ticket.ticket[0].startTime!) == GeneralLibrary().getStringFromDate(ticket.ticket[0].endTime!) {
			dates = dates.filter{$0 == GeneralLibrary().getStringFromDate(ticket.ticket[0].startTime!) }
		}
		
		tableView.reloadData()
		HUD.hide()
	}
	
}

//MARK:- TableView Related
extension SessionTicketsViewController: UITableViewDelegate{
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return dates.count
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataSortedByDates[dates[section]]!.count
	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return dates[section]
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("sessionTicketCell", forIndexPath: indexPath) as! SessionTicketsTableViewCell
		let row = indexPath.row
		let sec = indexPath.section
		
		let itemSection = dataSortedByDates[dates[sec]]
		let item = itemSection![row]
		cell.backgroundColor = UIColor.clearColor()
		
		cell.presentationName.text = item.name
		cell.presentationTime.text = "\(GeneralLibrary().getTimeFromDate(item.startTime!)) - \(GeneralLibrary().getTimeFromDate(item.endTime!))"
		cell.presentationLocation.text = item.room ?? ""
		cell.presentationPrice.text = "$ \(item.price!)"
		
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.performSegueWithIdentifier("goToSessionDetail", sender: indexPath)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "goToSessionDetail"{
			let vc = segue.destinationViewController as! SessionDetailViewController
			vc.event = event
			
			let row = sender!.row
			let sec = sender!.section
			
			let itemSection = dataSortedByDates[dates[sec]]
			let item = itemSection![row]
			vc.ticket = item
		}
	}
}