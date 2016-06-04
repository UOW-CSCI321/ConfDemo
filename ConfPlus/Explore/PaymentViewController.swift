//
//  PaymentViewController.swift
//  confDemo
//
//  Created by Matthew Boroczky on 15/03/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import Foundation
import UIKit
import PKHUD

class PaymentViewController: UIViewController, selectSessionTicketDelegate {
	
	@IBOutlet weak var tableView: UITableView!
	
	var tickets = [Coupon]()
	var event:Event!
	var sessionTickets = [Sessions]()
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
			
//			APIManager().makePayment(email, type: "Event Tickets", amount: String(self.totalPrice), payment_date: GeneralLibrary().getFullStringFromDate(NSDate())){
//				result in
//				if result{
//					for ticket in self.tickets {
//						APIManager().addSessionAttendee(self.event.event_id!, tickets: ticket)
//					}
//					self.performSegueWithIdentifier("goToSuccessPurchased", sender: self)
//				} else {
//					HUD.flash(.Label("Payment Failed, please try again"), delay: 1)
//				}
//			}
			self.performSegueWithIdentifier("goToSuccessPurchased", sender: self)
			alertcontroller.dismissViewControllerAnimated(true, completion: nil)
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
		alertcontroller.addAction(cancelAction)
		alertcontroller.addAction(paypalAction)
		self.presentViewController(alertcontroller, animated: true, completion: nil)
	}
	
	func selectSessionTicketDidFinish(controller: SessionTicketsViewController, email:String, session: [Sessions]) {
		for index in 0..<tickets.count{
			if tickets[index].email == email {
				let entry = tickets[index].ticket[0]
				tickets[index].ticket.removeAll()
				
				tickets[index].ticket.append(entry)
				for tit in session {
					tickets[index].ticket.append(tit)
				}
				
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
		
		var ticket:Sessions?
		if tickets.count == section {
			ticket = Sessions(title: "", price: String(self.totalPrice), name: "TOTAL", _class: "", type: "", venue: "", room: "", seat: "", startTime: nil, endTime: nil, conversation: nil, count: nil)
		} else {
			ticket = tickets[section].ticket[row]
		}
		
		cell.textLabel?.text = ticket!.name
		cell.detailTextLabel?.text = "$ \(ticket!.price!)"
		
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section < (tableView.numberOfSections - 1) && indexPath.row == 0{
			if self.sessionTickets.count > 0{
				self.performSegueWithIdentifier("goToSessionsTicket", sender: indexPath)
			}
		}
	}
}