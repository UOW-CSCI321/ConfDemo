//
//  TimeTableViewController.swift
//  confDemo
//
//  Created by Matthew Boroczky on 15/03/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import Foundation
import UIKit

class TimeTableViewController: UIViewController {
    
    var event:Event!
    let user = NSUserDefaults.standardUserDefaults()
    var myUser:User!
    var sessions = [Session]()
    
	@IBAction func backToTicketPurchaseView(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.hidesBarsOnSwipe = true
        
        let email = user.stringForKey("email")
        myUser = ModelHandler().getUser(email!)
        if myUser != nil
        {
            sessions = ModelHandler().getSessionsForEvent(event)
            //self.tableView.reloadData()
            
            //TEMP HERE
            //getMySessionsFromAPI(event, user: myUser)

        }

        
    }
    
    override func viewWillAppear(animated: Bool) {
        getMySessionsFromAPI(event, user: myUser)
    }
    
    func getMySessionsFromAPI(event:Event, user:User) {
        APIManager().getSessionsAndUserSessionsFromAPI(event, user: user) { result in
            print("hit")
            
            self.sessions = ModelHandler().getSessionsForEvent(event)
            print(self.sessions)
            //let numdays = self.countNumDays()
            //print(numdays)
        }
    }
    
    func countNumDays() -> Int //number of days is the number of sections
    {
        let count = self.sessions.count
        if count == 0
        {
            return 0
        }
        
        var diffdays = [String]()
        let d1 = GeneralLibrary().getStringFromDate(self.sessions[0].start_time!)
        
        diffdays.append(d1)
        print("initial value added: \(d1)")
       
        for i in 0..<count
        {
            let currSessionDate = GeneralLibrary().getStringFromDate(self.sessions[i].start_time!)
            print(currSessionDate)
            if !diffdays.contains(currSessionDate)
            {
                diffdays.append(currSessionDate)
                print("added")
            }
        }
        
        return diffdays.count
    }
    
}

extension TimeTableViewController: UITableViewDelegate{
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 3
        //return self.sessions.count
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
        //return countSessionInDay(section)
	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Date-\(section)"
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("presentationCell", forIndexPath: indexPath) as! TimetableTableViewCell
		
		cell.presentationName.text = "Presentation Name"
		cell.presentationTime.text = "HH:MM - HH:MM"
		cell.presentationLocation.text = "Building 1, Room 1"
		cell.presentationPrice.text = "AUD 1.00"
		
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.performSegueWithIdentifier("goToPresentationDetailView", sender: self)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "goToPresentationDetailView"{
			let vc = segue.destinationViewController as! TalksViewController
			// TODO: Assign Value into it
		}
	}
}