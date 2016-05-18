//
//  PaymentViewController.swift
//  confDemo
//
//  Created by Matthew Boroczky on 15/03/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import Foundation
import UIKit

class PaymentViewController: UIViewController {
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
    }
	
	
	//MARK: IBActions
	@IBAction func performPurchase(sender: AnyObject) {
		let alertcontroller = UIAlertController(title: "Payment Information", message: "Total Price: AUD 00.00 ", preferredStyle: .Alert)
		let paypalAction = UIAlertAction(title: "PayPal", style: .Default){ UIAlertAction in
			self.performSegueWithIdentifier("goToSuccessPurchased", sender: self)
			alertcontroller.dismissViewControllerAnimated(true, completion: nil)
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
		alertcontroller.addAction(cancelAction)
		alertcontroller.addAction(paypalAction)
		self.presentViewController(alertcontroller, animated: true, completion: nil)
	}

}

extension PaymentViewController: UITableViewDelegate{
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("informationCell", forIndexPath: indexPath) 
		
		cell.textLabel?.text = "ticket-\(indexPath.row)"
		cell.detailTextLabel?.text = "AUD 00.00"
		
		return cell
	}
}