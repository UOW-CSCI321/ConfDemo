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
    var numSections:Int!
    var diffdays = [String]()
    
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
            
            
            self.sessions = ModelHandler().getSessionsForEvent(event)
            
            //let numdays = self.countNumDays()
            //print(numdays)
            
//            let first = self.countNumRowsForSection(1)
//            let second = self.countNumRowsForSection(2)
//            let third = self.countNumRowsForSection(3)
//            let fourth = self.countNumRowsForSection(4)
//            print("num in each section \(first) \(second) \(third) \(fourth)")
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
        //print("initial value added: \(d1)")
       
        for i in 0..<count
        {
            let currSessionDate = GeneralLibrary().getStringFromDate(self.sessions[i].start_time!)
            //print(currSessionDate)
            if !diffdays.contains(currSessionDate)
            {
                diffdays.append(currSessionDate)
                //print("added")
            }
        }
        
        return diffdays.count
    }
    
    func countNumRowsForSection(section:Int) -> Int? {
        
        //DUMMY
//        var sessions = [String]()
//        sessions.append("2016-10-02")
//        sessions.append("2016-10-02")
//        
//        sessions.append("2016-10-03")
//        sessions.append("2016-10-03")
//        
//        sessions.append("2016-10-04")
//        sessions.append("2016-10-04")
//        sessions.append("2016-10-04")
//        
//        sessions.append("2016-10-05")
//        sessions.append("2016-10-05")
//        sessions.append("2016-10-05")
//        sessions.append("2016-10-05")
//        sessions.append("2016-10-05")
//        sessions.append("2016-10-05")
        
        let sectionM  = section + 1
       
        let count = self.sessions.count
        //DUMMY
        //let count = sessions.count
        
        self.diffdays = [String]()
        let d1 = GeneralLibrary().getDateAsAusStyleString(self.sessions[0].start_time!) //sessions[0]
        //DUMMY
        //let d1 = sessions[0]
        
        self.diffdays.append(d1)
        //print("initial value added: \(d1)")
        
        var i = 0
        var counter = 0
        
        while self.diffdays.count <= sectionM
        {
            if i == count
            {
                //print("last element \(count) counter is \(counter)")
                return counter
            }
            let currSessionDate = GeneralLibrary().getDateAsAusStyleString(self.sessions[i].start_time!)
            //DUMMY
            //let currSessionDate = sessions[i]
            //print(currSessionDate)
            if !self.diffdays.contains(currSessionDate)
            {
                self.diffdays.append(currSessionDate)
                //print("added")
                //print(diffdays.count)
                if self.diffdays.count - 1 == sectionM
                {
                    //print("there are \(counter) presentations in the section for day \(section)")
                    return counter
                }
                else {
                    counter = 0 //reset to count the number of presentations for the next day
                }
            }
            i += 1
            counter += 1
        }
        
        
        return nil
    }
    
}

extension TimeTableViewController: UITableViewDelegate{
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        self.numSections = self.countNumDays()
        return self.numSections
        
		//return 3
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let numRows = countNumRowsForSection(section)
        return numRows!
		//return 2
        //return countSessionInDay(section)
	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.diffdays.count > 0
        {
            let day = self.diffdays[section]
            print(day)
            return day
        }
        
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