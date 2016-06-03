//
//  HistoryTableViewController.swift
//  confDemo
//
//  Created by Matthew Boroczky on 15/03/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import PKHUD

struct Payments {
	var type: String?
	var amount: String?
}

class HistoryTableViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	var payment = [Payments]()
	
	let user = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		
		if let email = user.stringForKey("email"){
			HUD.show(.Progress)
			APIManager().getPaymentHistory(email){ result, json in
				self.payment.removeAll()
				
				if result {
					for i in 0 ..< json!["data"].count {
						let data = json!["data"][i]
						self.payment.append(Payments(type: data["type"].string, amount: data["amount"].string))
					}
				}
				HUD.hide()
				self.tableView.reloadData()
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
			
			cell.textLabel!.text = "\(payment[row].type!)"
			cell.detailTextLabel?.text = "$ \(payment[row].amount!)"
		} else {
			cell.textLabel!.text = "No payment history yet."
			cell.detailTextLabel?.text = ""
		}
		
		return cell
	}
}