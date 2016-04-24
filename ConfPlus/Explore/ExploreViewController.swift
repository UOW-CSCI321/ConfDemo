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

    @IBOutlet var exploreEventsTableView: UIView!
    
    
   // var eventArray:[Event] = []
    var eventArray = [Event]()
    
    /*var eventName:String = ""
    var eventStartString:String = ""
    var eventEndString:String = ""
    var desc:String = ""
    var posterUrl:String = ""*/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(animated: Bool) {
        data_request()
        self.exploreEventsTableView.reloadInputViews()
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("exploreCell", forIndexPath: indexPath) as! ExploreTableViewCell
        cell.eventName.text = "name"
        cell.eventDate.text = "date"

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let eventEntity = NSEntityDescription.entityForName("Event", inManagedObjectContext: context)

        // Fetch
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = eventEntity
        fetchRequest.returnsObjectsAsFaults = false

        do {
            let result = try context.executeFetchRequest(fetchRequest) as! [Event]

            if(result.count > 1)
            {
                print("error should only have retrieved one record. retrieved \(result.count)")

                print(result)
            } else {
                cell.eventName.text = result[0].name
                cell.eventDate.text = "\(self.dateToFullStyleString(result[0].from_date!)) to \(self.dateToFullStyleString(result[0].to_date!))"
                //TODO: poster stuff
            }
            print(result)
        } catch {
        let fetchError = error as NSError
        print(fetchError)
        }


//        cell.eventName.text = eventName
//        cell.eventDate.text = "\(eventStartString) to \(eventEndString)"
 
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
    
    func data_request()
    {
        //coredata
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        let eventEntity = NSEntityDescription.entityForName("Event", inManagedObjectContext: context)
        
        //post request
        let paramaters = [
            "method" : "getEvent",
            "event_id" : "1"
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
                        //create an event object
//                        var e:Event
                        let json = JSON(value)
//                        e.name = json["data"][0]["name"].stringValue
//                        //let password = json["data"][0]["password"].stringValue //data[0].password
//                        //let eventStartString = self.dateToFullStyleString(json["data"][0]["from_date"].stringValue)
//                        e.from_date = self.serverStringToDate(json["data"][0]["from_date"].stringValue)
//                        //let eventEndString = self.dateToFullStyleString(json["data"][0]["to_date"].stringValue)
//                        e.to_date = self.serverStringToDate(json["data"][0]["to_date"].stringValue)
//                        e.desc = json["data"][0]["description"].stringValue
//                        e.poster_url = json["data"][0]["poster_url"].stringValue
//                        self.eventArray.append(e)
                        let aevent = NSEntityDescription.insertNewObjectForEntityForName("Event", inManagedObjectContext: context) as! Event
                        aevent.name = json["data"][0]["name"].stringValue
                        aevent.from_date = self.serverStringToDate(json["data"][0]["from_date"].stringValue)
                        aevent.to_date = self.serverStringToDate(json["data"][0]["to_date"].stringValue)
                        aevent.desc = json["data"][0]["description"].stringValue
                        aevent.poster_url = json["data"][0]["poster_url"].stringValue
                        aevent.event_id = json["data"][0]["event_id"].intValue
     
                        
                    }
                case .Failure(let error):
                    print(error)
                    
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
        
        
        
        do {
            try context.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }

        
    }


}
