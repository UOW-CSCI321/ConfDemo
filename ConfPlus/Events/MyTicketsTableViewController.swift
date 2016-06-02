//
//  MyTicketsTableViewController.swift
//  confDemo
//
//  Created by Matthew Boroczky on 15/03/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import Foundation
import UIKit

class MyTicketsTableViewController: UITableViewController {
	
	var tickets = [Ticket_Record]()
    var event:Event!
    let user = NSUserDefaults.standardUserDefaults()
    //var myUser:User!
    var email:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        email = user.stringForKey("email")
        //print("email \(email), eventid: \(event.event_id)")
        
        //get tickets from model handler for users email
        if let myUser = ModelHandler().getUser(email!) {
            tickets = ModelHandler().getTicketsForUser(myUser)!
            self.tableView.reloadData()
        }
        
		populateNavigationBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        //let email = self.user.stringForKey("email")
        //let user = ModelHandler().getUser(email!)
        if let myUser = ModelHandler().getUser(self.email) {
            getMyTicketsFromAPI(self.event, user: myUser)
            tickets = ModelHandler().getTicketsForUser(myUser)!
            self.tableView.reloadData()
        }
    }
    
    
    func getMyTicketsFromAPI(event:Event, user:User)
    {
        APIManager().getUserTicketsForEvent(event.event_id!, email: user.email!){ result, json in
            if result {
                //print(json)
                let count = json!["data"].count
                for i in 0..<count
                {
                    let dataForSingleTicket = json!["data"][i]
                    //print(dataForSingleTicket)
                    let ticket = ModelHandler().addNewTicket(dataForSingleTicket)
                    ModelHandler().saveTicketForUser(ticket, user: user)
                }
            }
        }
    }
    
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tickets.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("ticketListCell", forIndexPath: indexPath)
		let row = indexPath.row
		
		cell.textLabel!.text = tickets[row].ticket_name
		cell.detailTextLabel!.text = tickets[row].room_name
		
		return cell
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		let indexPath:NSIndexPath = self.tableView.indexPathForSelectedRow!
		let vc = segue.destinationViewController as! TicketProfileTableViewController
		vc.ticket = tickets[indexPath.row]
	}

}


// MARK: - Navigation Bar Related
extension MyTicketsTableViewController{
	func populateNavigationBar(){
		self.navigationController?.hidesBarsOnSwipe = true
		
		let contact = UIBarButtonItem(image: UIImage(named: "security32"), style: .Plain, target: self, action: #selector(performSecurityView))
		let location = UIBarButtonItem(image: UIImage(named: "second"), style: .Plain, target: self, action: #selector(performLocationView))
		
		let space = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: self, action: nil)
		
		let buttons = [contact, space, location]
		
		self.navigationItem.setRightBarButtonItems(buttons, animated: true)
	}
	
	func performSecurityView(){
		let storyboard : UIStoryboard = UIStoryboard(name: "EventAssistServices", bundle: nil)
		let vc : SecurityViewController = storyboard.instantiateViewControllerWithIdentifier("SecurityViewController") as! SecurityViewController
        vc.event = self.event
		
		let navigationController = UINavigationController(rootViewController: vc)
		
		self.presentViewController(navigationController, animated: true, completion: nil)
	}
	
	func performLocationView(){
		let storyboard : UIStoryboard = UIStoryboard(name: "EventAssistServices", bundle: nil)
		let vc : EventLocationViewController = storyboard.instantiateViewControllerWithIdentifier("EventLocationViewController") as! EventLocationViewController
        vc.event = self.event
		
		let navigationController = UINavigationController(rootViewController: vc)
		
		self.presentViewController(navigationController, animated: true, completion: nil)
	}
}