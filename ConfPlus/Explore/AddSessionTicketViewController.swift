//
//  AddSessionTicketViewController.swift
//  ConfPlus
//
//  Created by CY Lim on 6/06/2016.
//  Copyright © 2016 Conf+. All rights reserved.
//

import UIKit

protocol selectSessionTicketDelegate{
	func selectSessionTicketDidFinish(controller:AddSessionTicketViewController, email:String, col:Int, session:[Tickets])
}

class AddSessionTicketViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var updateButton: UIButton!
	
	var delegate:selectSessionTicketDelegate?
	var col:Int!
	var ticket:Coupon!
	
	var selectedSessions = Dictionary<String, [Tickets]>()
	var titles = [String]()

	@IBAction func performUpdateTickets(sender: AnyObject) {
		if let del = delegate {
			var sessions = [Tickets]()
			for section in 0..<tableView.numberOfSections{
				for row in 0..<tableView.numberOfRowsInSection(section){
					tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: row, inSection: section) , atScrollPosition: UITableViewScrollPosition.Top, animated: false)
					let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: section)) as! AddSessionTicketTableViewCell
					
					//TODO: A way to save checkmark, cell might have issues
					if cell.accessoryType == .Checkmark {
						let itemSection = selectedSessions[titles[section]]
						let item = itemSection![row]
						
						if sessions.count == 0 {
							sessions = [item]
						} else {
							sessions.append(item)
						}
						
					}
				}
			}
			
			del.selectSessionTicketDidFinish(self, email: ticket.email, col: col, session: sessions)
			
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setDataForPresent()
    }
	
	func setDataForPresent(){
		setText()
		titles = Array(selectedSessions.keys)
		tableView.reloadData()
	}
	
	func setText(){
		navigationItem.title = "Add sessions".localized()
		
		updateButton.setTitle("Update Session Tickets".localized(), forState: .Normal)
	}
}

//MARK:- TableView Related
extension AddSessionTicketViewController: UITableViewDelegate{
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return titles.count
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return selectedSessions[titles[section]]!.count
	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return titles[section]
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("addSessionTicketCell", forIndexPath: indexPath) as! AddSessionTicketTableViewCell
		let row = indexPath.row
		let sec = indexPath.section
		
		let itemSection = selectedSessions[titles[sec]]
		let item = itemSection![row]
		
		if row == 0 {
			cell.accessoryType = .Checkmark
		} else {
			cell.accessoryType = .None
		}
	
		cell.name.text = item.name
		cell._class.text = item._class
		cell.type.text = item.type
		cell.price.text = "$ \(item.price!)"
		
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		for row in 0..<tableView.numberOfRowsInSection(indexPath.section){
			let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: indexPath.section)) as! AddSessionTicketTableViewCell
			cell.accessoryType = .None
		}
		let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath.row, inSection: indexPath.section)) as! AddSessionTicketTableViewCell
		cell.accessoryType = .Checkmark
	}
}