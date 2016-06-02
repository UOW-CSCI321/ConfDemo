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

class SessionTicketsViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	
	var sessionTickets = [Tickets]()
	var ticket:Coupon!
	var event:Event!
	
	var dataSortedByDates = Dictionary<String, [Tickets]>()
	var dates = [String]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		setDataForPresent()
	}
	
	func setDataForPresent(){
		dates.removeAll()
		dataSortedByDates.removeAll()
		
		HUD.show(.Progress)
		for session in sessionTickets  {
			let date = self.getStringFromDate(session.startTime!)
			
			if self.dataSortedByDates.indexForKey(date) == nil {
				self.dataSortedByDates[date] = [session]
			} else {
				self.dataSortedByDates[date]!.append(session)
			}
			
			self.dataSortedByDates[date]?.sortInPlace({ $0.startTime!.compare($1.startTime!) == NSComparisonResult.OrderedAscending })
		}
		dates = Array(dataSortedByDates.keys).sort(<)
		
		for index in (0..<dates.count).reverse() {
			if !(dates[index] >= getStringFromDate(ticket.ticket[0].startTime!) && dates[index] <= getStringFromDate(ticket.ticket[0].endTime!)){
				dates.removeAtIndex(index)
			} else if !(dates[index] >= getStringFromDate(ticket.ticket[0].startTime!) && dates[index] <= getStringFromDate(ticket.ticket[0].endTime!)){
				dates.removeAtIndex(index)
			}
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
		
		let cell = tableView.dequeueReusableCellWithIdentifier("presentationCell", forIndexPath: indexPath) as! TimetableTableViewCell
		let row = indexPath.row
		let sec = indexPath.section
		
		let itemSection = dataSortedByDates[dates[sec]]
		let item = itemSection![row]
		cell.backgroundColor = UIColor.clearColor()
		
		cell.presentationName.text = item.name
		cell.presentationTime.text = "\(getTimeFromDate(item.startTime!)) - \(getTimeFromDate(item.endTime!))"
		cell.presentationLocation.text = item.room ?? ""
		cell.presentationPrice.text = "$ \(item.price!)"
		
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		//self.performSegueWithIdentifier("goToPresentationDetailView", sender: self)
	}
}

//MARK:- Helpers function
extension SessionTicketsViewController {
	func unwrapPrice(price:String) -> String{
		return price.componentsSeparatedByString(" ").last!
	}
	
	func getTimeFromDate(date:NSDate) -> String {
		let dateFormatter = NSDateFormatter()
		dateFormatter.timeZone = NSTimeZone(name: "GMT")
		dateFormatter.dateFormat = "HH:mm"
		
		return dateFormatter.stringFromDate(date)
	}
	
	func getStringFromDate(date:NSDate) -> String{
		let dateFormatter = NSDateFormatter()
		dateFormatter.timeZone = NSTimeZone(name: "GMT")
		dateFormatter.dateFormat = "YYYY-MM-dd"
		
		return dateFormatter.stringFromDate(date)
	}
	
	func getDateFromString(date:String) -> NSDate{
		let dateFormatter = NSDateFormatter()
		dateFormatter.timeZone = NSTimeZone(name: "GMT")
		dateFormatter.dateFormat = "YYYY-MM-dd"
		
		return dateFormatter.dateFromString(date)!
	}
}