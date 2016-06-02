//
//  PaymentViewController.swift
//  confDemo
//
//  Created by Matthew Boroczky on 15/03/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import Foundation
import UIKit

class PaymentViewController: UIViewController, selectSessionTicketDelegate {
	
	@IBOutlet weak var tableView: UITableView!
	
	var tickets = [Coupon]()
	var event:Event!
	var sessionTickets = [Tickets]()
	var totalPrice:Double = 0.0
	
	let user = NSUserDefaults.standardUserDefaults()
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		updateTotalPrice()
	}
	
	//MARK: IBActions
	@IBAction func performPurchase(sender: AnyObject) {
		guard let email = user.stringForKey("email") else {
			performLogin()
			return
		}
		
		let alertcontroller = UIAlertController(title: "Payment Information", message: "Total Price: $ \(totalPrice)", preferredStyle: .Alert)
		let paypalAction = UIAlertAction(title: "PayPal", style: .Default){ UIAlertAction in
			self.performSegueWithIdentifier("goToSuccessPurchased", sender: self)
			alertcontroller.dismissViewControllerAnimated(true, completion: nil)
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
		alertcontroller.addAction(cancelAction)
		alertcontroller.addAction(paypalAction)
		self.presentViewController(alertcontroller, animated: true, completion: nil)
	}
	
	func selectSessionTicketDidFinish(controller: SessionTicketsViewController, email:String, session: [Tickets]) {
		for ticket in tickets{
			if ticket.email == email {
				let entry = ticket.ticket[0]
//				ticket.ticket.removeAll()
//				
//				ticket.ticket.append(entry)
//				ticket.ticket.append(session)
				break
			}
		}
		controller.navigationController?.popViewControllerAnimated(true)
		tableView.reloadData()
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "goToSessionsTicket" {
			let col = sender!.section
			let vc = segue.destinationViewController as! SessionTicketsViewController
			vc.sessionTickets = sessionTickets
			vc.ticket = tickets[col!]
			vc.event = event
			vc.delegate = self
		}
	}
	
	func updateTotalPrice(){
		totalPrice = 0.0
		for section in 0..<tableView.numberOfSections - 1{
			for row in 0..<tableView.numberOfRowsInSection(section){
				let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: section))
				
				totalPrice += Double(GeneralLibrary().unwrapPrice((cell?.detailTextLabel?.text)!))!
			}
		}
		tableView.reloadData()
	}
	
	func performLogin(){
		let storyboard : UIStoryboard = UIStoryboard(name: "Account", bundle: nil)
		let vc : LoginViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
		
		let navigationController = UINavigationController(rootViewController: vc)
		
		
		self.presentViewController(navigationController, animated: true, completion: nil)
	}
}

//MARK:- TableView Related
extension PaymentViewController: UITableViewDelegate{
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return tickets.count + 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if tickets.count == section { return 1 }
		return tickets[section].ticket.count
	}

	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if tickets.count == section { return "Total" }
		return "\(tickets[section].name) - \(tickets[section].email)"
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("informationCell", forIndexPath: indexPath)
		let section = indexPath.section
		let row = indexPath.row
		
		var ticket:Tickets?
		if tickets.count == section {
			ticket = Tickets(title: "", price: String(self.totalPrice), name: "TOTAL", _class: "", type: "", venue: "", room: "", seat: "", startTime: nil, endTime: nil, count: nil)
		} else {
			ticket = tickets[section].ticket[row]
		}
		
		cell.textLabel?.text = ticket!.name
		cell.detailTextLabel?.text = "$ \(ticket!.price!)"
		
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section < (tableView.numberOfSections - 1){
			self.performSegueWithIdentifier("goToSessionsTicket", sender: indexPath)
		}
	}
}