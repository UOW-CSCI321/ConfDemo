//
//  PersonalDetailsViewController.swift
//  confDemo
//
//  Created by Matthew Boroczky on 15/03/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import UIKit

class PersonalDetailsViewController: UIViewController {
	
	var TOTAL_TICKET_QUANTITY:Int = 1
	var ticketName = [String]()
	let type = ["name", "email"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
    }
}

extension PersonalDetailsViewController: UITableViewDelegate {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return TOTAL_TICKET_QUANTITY
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return type.count
	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "\(ticketName[section % ticketName.count])-\(section)"
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("personalCell", forIndexPath: indexPath) as! PersonalDetailsTableViewCell
		
		cell.detailType.text = type[indexPath.row]
		cell.typeResponseTextField.placeholder = type[indexPath.row]
		
		return cell
	}
}