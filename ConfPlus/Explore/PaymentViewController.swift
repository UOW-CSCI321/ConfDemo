//
//  PaymentViewController.swift
//  confDemo
//
//  Created by CY Lim on 15/03/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import Foundation
import UIKit
import PKHUD

class PaymentViewController: UIViewController, selectSessionTicketDelegate {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var confirmButton: UIButton!
	@IBOutlet weak var disclosureText: UILabel!
	
	var tickets = [Coupon]()
	var event:Event!
	var sessionTickets = Dictionary<String, [Tickets]>()
	var totalPrice:Double = 0.0
	
	let user = NSUserDefaults.standardUserDefaults()
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		setText()
		updateTotalPrice()
	}
	
	func setText(){
		navigationItem.title = "Confirmation".localized()
		
		confirmButton.setTitle("Confirm Purchase".localized(), forState: .Normal)
		
		if sessionTickets.count > 0 {
			disclosureText.text = "warnSelect".localized()
		} else {
			disclosureText.text = "warnComplete".localized()
		}
		
	}
	
	//MARK: IBActions
	@IBAction func performPurchase(sender: AnyObject) {
		guard let email = user.stringForKey("email") else {
			performLogin()
			return
		}
		
		let message = "Total".localized() + ": $ " + String(totalPrice)
		let alertcontroller = UIAlertController(title: "Payment Information".localized(), message: message, preferredStyle: .Alert)
		let paypalAction = UIAlertAction(title: "Credit Card".localized(), style: .Default){ UIAlertAction in
			self.makePayment(email)
			alertcontroller.dismissViewControllerAnimated(true, completion: nil)
		}
		let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .Cancel, handler: nil)
		alertcontroller.addAction(cancelAction)
		alertcontroller.addAction(paypalAction)
		self.presentViewController(alertcontroller, animated: true, completion: nil)
	}
	
	func makePayment(email:String){
		if event.payee == nil { event.payee = "merchant@cy.my" }
		if event.cardNum == nil { event.cardNum = "1234 5678 9012 3456" }
		
		HUD.show(.Progress)
		APIManager().makePayment(email, type: "Event Tickets".localized(),
		                         amount: String(self.totalPrice),
		                         payment_date: GeneralLibrary().getFullStringFromDate(NSDate()),
		                         payee: event.payee!,
		                         cardNum: event.cardNum!){ result in
			if result{
				for ticket in self.tickets {
					APIManager().addSessionAttendee(self.event.event_id!, tickets: ticket)
				}
				HUD.hide()
				self.performSegueWithIdentifier("goToSuccessPurchased", sender: self)
			} else {
				HUD.hide()
				HUD.flash(.Label("warnPaymentFail".localized()), delay: 1)
			}
		}
		self.performSegueWithIdentifier("goToSuccessPurchased", sender: self)
	}
	
	func selectSessionTicketDidFinish(controller: AddSessionTicketViewController, email:String, col:Int, session: [Tickets]) {
		if tickets[col].email == email {
			let entry = tickets[col].ticket[0]
			tickets[col].ticket.removeAll()
			
			tickets[col].ticket.append(entry)
			for tit in session {
				tickets[col].ticket.append(tit)
			}
		}
		controller.dismissViewControllerAnimated(true, completion: nil)
		tableView.reloadData()
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "goToSessionsTicket" {
			let col = sender!.section
			let nv = segue.destinationViewController as! UINavigationController
			let vc = nv.topViewController as! SessionTicketsViewController
			vc.sessionTickets = sessionTickets
			vc.ticket = tickets[col!]
			vc.event = event
			vc.col = col
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
		if tickets.count == section { return "Total".localized() }
		return "\(tickets[section].name) - \(tickets[section].email)"
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("informationCell", forIndexPath: indexPath)
		let section = indexPath.section
		let row = indexPath.row
		
		var ticket:Tickets?
		if tickets.count == section {
			ticket = Tickets(title: "", price: String(self.totalPrice), name: "Total".localized(), _class: "", type: "", venue: "", room: "", seat: "", startTime: nil, endTime: nil, endSales:nil, count: nil)
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