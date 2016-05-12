//
//  HistoryTableViewController.swift
//  confDemo
//
//  Created by Matthew Boroczky on 15/03/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import Foundation
import UIKit

class HistoryTableViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	var payment = [Payment]()
	
	let user = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		payment = ModelHandler().getPaymentHistory()
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		if let email = user.stringForKey("email"){
			APIManager().getPaymentHistory(email){ result in
				if result {
					self.payment = ModelHandler().getPaymentHistory()
					self.tableView.reloadData()
				}
			}
		}
		
	}
}

extension HistoryTableViewController: UITableViewDelegate{
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if payment.count > 0 {
			return payment.count
		} else {
			return 1
		}
		
	}
	
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("historyCell", forIndexPath: indexPath)
		
		if payment.count > 0 {
			let row = indexPath.row
			
			cell.textLabel!.text = "\(payment[row].payment_id)"
			cell.detailTextLabel?.text = "$ \(payment[row].amount)"
		} else {
			cell.textLabel!.text = "No payment history yet."
			cell.detailTextLabel?.text = ""
		}
		
		return cell
	}
}