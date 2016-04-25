//
//  ExploreViewController.swift
//  confDemo
//
//  Created by CY Lim on 2015/10/08.
//  Copyright © 2015年 CY Lim. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData


class ExploreViewController: UIViewController, UITableViewDelegate {

    
    @IBOutlet var EventsTableView: UITableView!
    var eventArray = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data_request()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let aevent = eventArray[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("exploreCell", forIndexPath: indexPath) as! ExploreTableViewCell
        cell.eventName.text = aevent.name
        cell.eventDate.text = dateToFullStyleString(aevent.from_date!)
        print("indexpath: \(indexPath.row)")
        return cell
    }
 
    func serverStringToDate(dateString:String) -> NSDate
    {
        //move into model class for event eventually
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "GMT")
        //dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
        
        let d1 = dateFormatter.dateFromString(dateString)
        //print(dateStart)
        return d1!
    }
    
    func dateToFullStyleString(date:NSDate) -> String
    {
        
        let df = NSDateFormatter()
        df.dateStyle = NSDateFormatterStyle.FullStyle
        let dstring = df.stringFromDate(date)
        //print(dstring)
        return dstring
    }
    
    /*func serverStringToDateToString(dateString:String) -> String
    {
        let adateObj = serverStringToDate(dateString)
        let newString = dateToFullStyleString(adateObj)
        return newString
    }*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var indexPath:NSIndexPath = self.EventsTableView.indexPathForSelectedRow!
        var eventVC:EventDetailTableViewController = segue.destinationViewController as! EventDetailTableViewController
        //eventVC.descriptionTextView.text =
        eventVC.selectedEvent = eventArray[indexPath.row]
        
    }
    
    func data_request()
    {
        //coredata
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        let eventEntity = NSEntityDescription.entityForName("Event", inManagedObjectContext: context)
        
        //post request
        let paramaters = [
            "method" : "getEventsByTag",
            "tag_name" : "testTag"
        ] //at the moment the api call need event id
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let serverAdd = defaults.stringForKey("server")
        {
            Alamofire.request(.POST, serverAdd, parameters: paramaters).responseJSON {
                response in switch response.result
                {
                case .Success:
                    if let value = response.result.value
                    {
                        let json = JSON(value)

                        for i in 0 ..< json["data"].count
                        {
                            let aevent = NSEntityDescription.insertNewObjectForEntityForName("Event", inManagedObjectContext: context) as! Event
                            aevent.name = json["data"][i]["name"].stringValue
                            //print("name: \(aevent.name)")
                            aevent.from_date = self.serverStringToDate(json["data"][i]["from_date"].stringValue)
                            //print("from date:\(aevent.from_date)")
                            aevent.to_date = self.serverStringToDate(json["data"][i]["to_date"].stringValue)
                            //print("to date:\(aevent.to_date)")
                            aevent.desc = json["data"][i]["description"].stringValue
                            //print("desc: \(aevent.desc)")
                            aevent.poster_url = json["data"][i]["poster_url"].stringValue
                            //print("poster: \(aevent.poster_url)")
                            aevent.event_id = json["data"][i]["event_id"].intValue
                            //print("id: \(aevent.event_id)")
                            
                            self.eventArray.append(aevent);

                        }
                        self.EventsTableView.reloadData()
                    }
                case .Failure(let error):
                    print(error)
                    //handle if there is no internet connection
                    
                }
                
            }
            
        }else {
            print("server not set in LoginViewController")
        }
        
        // Save
        //let user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: context) as! User
       // eventArray = NSEntityDescription.insertNewObjectForEntityForName("Event", inManagedObjectContext: context) as! [Event]
        //        user.username = "matts_test_username"
        //        user.password = "matts_test_password"
        //        user.first_name = "first_name_test"
        //        user.last_name = "last_name_test"
        //        user.email = "email_test"
        
        
        
//        do {
//            try context.save()
//        } catch {
//            fatalError("Failure to save context: \(error)")
//        }

        
    }


}
