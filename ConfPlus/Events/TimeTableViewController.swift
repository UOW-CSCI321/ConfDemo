//
//  TimeTableViewController.swift
//  confDemo
//
//  Created by Matthew Boroczky on 15/03/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import Foundation
import UIKit
import MPGNotification

class TimeTableViewController: UIViewController {
    
	@IBOutlet weak var segmentControl: UISegmentedControl!
    var event:Event!
    let user = NSUserDefaults.standardUserDefaults()
    var myUser:User!
    var sessions = [Session]()
    var numSections:Int!
    var diffdays = [String]()
    var prevSection:Int!
    
    @IBOutlet weak var timetableTableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
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
            sessions = ModelHandler().getSessionsForEventForUser(event, user: myUser)
            self.timetableTableView.reloadData()
            //self.tableView.reloadData()
            
            //TEMP HERE
            //getMySessionsFromAPI(event, user: myUser)

        }

        
    }
    
    override func viewWillAppear(animated: Bool) {
		setText()
		
        getMySessionsFromAPI(event, user: myUser)
    }
	
	func setText(){
		navigationItem.title = "Timetable".localized()
		
		segmentControl.setTitle("Current".localized(), forSegmentAtIndex: 0)
		segmentControl.setTitle("General".localized(), forSegmentAtIndex: 1)
		
	}
	
    @IBAction func segmentPressed(sender: AnyObject) {
        if segment.selectedSegmentIndex == 0{
            //mine
            self.sessions = ModelHandler().getSessionsForEventForUser(event, user: myUser)
            self.timetableTableView.reloadData()
            
        } else{
            //general
            sessions = ModelHandler().getSessionsForEvent(event)
            self.timetableTableView.reloadData()
        }
    }
    
    func getMySessionsFromAPI(event:Event, user:User) {
        let notification = MPGNotification(title: "Updating".localized(), subtitle: "warnUpdateMessage".localized(), backgroundColor: UIColor.orangeColor(), iconImage: nil)
        notification.duration = 60
        notification.show()

        APIManager().getSessionsAndUserSessionsFromAPI(event, user: user) { result in
  
            notification.dismissWithAnimation(true)
            self.sessions = ModelHandler().getSessionsForEventForUser(event, user: user)
            //print("printing sessions")
            //print(self.sessions)
            
            self.timetableTableView.reloadData()
            
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

//        print("PRINTIN SESSION IN COUNT NUM ROWS FOR SECTION")
//        print(self.sessions)
//        print("END")
       
        let count = self.sessions.count
        //DUMMY
        //let count = sessions.count
        
        
        self.diffdays = [String]()
        let d1 = GeneralLibrary().getDateAsAusStyleString(self.sessions[0].start_time!) //sessions[0]
//        let d1 = GeneralLibrary().getStringFromDate(self.sessions[0].start_time!)
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
//            let currSessionDate = GeneralLibrary().getStringFromDate(self.sessions[i].start_time!)
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
    
    func getSessionsForSection(section:Int) -> [Session]? {
        let sectionM  = section + 1
        
        let count = self.sessions.count
        
        var sessionsForDay = [Session]()
        
        self.diffdays = [String]()
        let d1 = GeneralLibrary().getDateAsAusStyleString(self.sessions[0].start_time!) //sessions[0]
        
        self.diffdays.append(d1)
        //print("initial value added: \(d1)")
        
        var i = 0
        var counter = 0
        
        while self.diffdays.count <= sectionM
        {
            if i == count
            {
                //print("last element \(count) counter is \(counter)")
                //return counter
                return sessionsForDay
            }
            let currSessionDate = GeneralLibrary().getDateAsAusStyleString(self.sessions[i].start_time!)
            sessionsForDay.append(self.sessions[i])
            //print(sessionsForDay)
          
            if !self.diffdays.contains(currSessionDate)
            {
                self.diffdays.append(currSessionDate)
                sessionsForDay.removeLast()
//                print("WE SHOULD HAVE SESSIONS FOR DAY")
//                print(sessionsForDay)
//                print("DONE")
                //print("added")
                //print(diffdays.count)
                if self.diffdays.count - 1 == sectionM
                {
                    //print("there are \(counter) presentations in the section for day \(section)")
                    //return counter
                    return sessionsForDay
                }
                else {
                    counter = 0 //reset to count the number of presentations for the next day
                    sessionsForDay = [Session]()
                    sessionsForDay.append(self.sessions[i])
                }
            }
            i += 1
            counter += 1
        }
        
        
        return nil

    }
    
//}

//extension TimeTableViewController: UITableViewDelegate{
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
            //print(self.diffdays.count)
            if self.diffdays.count > section
            {
                let day = self.diffdays[section]
                //print(day)
                return day
            }
        }
        
		return "Date-\(section)"
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("presentationCell", forIndexPath: indexPath) as! TimetableTableViewCell
		
		cell.presentationName.text = "Presentation Name"
		cell.presentationTime.text = "HH:MM - HH:MM"
		cell.presentationLocation.text = "Building 1, Room 1"
		cell.presentationPrice.text = ""
        
        cell.addToCartLabel.text = ""
        cell.addToCartButton.hidden = true
        
//        print("INDEX PATH: row \(indexPath.row), section \(indexPath.section)")
//        let first = getSessionsForSection(0)
//        let second = getSessionsForSection(1)
//        let third = getSessionsForSection(2)
//        print("first")
//        print(first)
//        print("second")
//        print(second)
//        print("third")
//        print(third)
        let sessionForSection = getSessionsForSection(indexPath.section)
        //let thisSession = sessionForSection![indexPath.row]
        
        if sessionForSection!.count > 0
        {
            cell.presentationName.text = sessionForSection![indexPath.row].title
            
            var time = GeneralLibrary().getTimeFromDate(sessionForSection![indexPath.row].start_time!)
            time += " - "
            time += GeneralLibrary().getTimeFromDate(sessionForSection![indexPath.row].end_time!)
            cell.presentationTime.text = time
            
            var location = sessionForSection![indexPath.row].room_name            
            cell.presentationLocation.text = location
            
        }
        
		
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let sessions = self.getSessionsForSection(indexPath.section)
        let theSession = sessions![indexPath.row]
        self.performSegueWithIdentifier("TimetableToTalk", sender: theSession)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //print(segue.identifier)
		if segue.identifier == "TimetableToTalk"{
			let vc = segue.destinationViewController as! TalksViewController
            vc.mySession = sender as! Session
            vc.segment = self.segment
		}
	}
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "goToSessionDetail"{
//            let vc = segue.destinationViewController as! SessionDetailViewController
//            vc.event = event
//            
//            let row = sender!.row
//            let sec = sender!.section
//            
//            let itemSection = dataSortedByDates[dates[sec]]
//            let item = itemSection![row]
//            vc.ticket = item
//        }
//    }
//}
}