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
	
	var delegate:selectSessionTicketDelegate?
	var col:Int!
	var ticket:Coupon!

	@IBAction func performUpdateTickets(sender: AnyObject) {
		if let del = delegate {
			var sessions = [Tickets]()
			for section in 0..<tableView.numberOfSections{
				for row in 0..<tableView.numberOfRowsInSection(section){
					let cell:SessionTicketsTableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: section)) as! SessionTicketsTableViewCell
					
					if cell.backgroundColor == UIColor.init(red: 0, green: 0.8, blue: 0, alpha: 0.2) {
						let itemSection = dataSortedByDates[dates[section]]
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
    }

}
