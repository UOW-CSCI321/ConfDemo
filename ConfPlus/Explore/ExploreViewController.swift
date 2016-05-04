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
import Foundation


class ExploreViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet var EventsTableView: UITableView!
    var eventArray = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("https://6f7a5a2d.ngrok.io/api/v1", forKey: "server");
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
    
//    func imageTypeIsValid(base64string : String) -> String
//    {
//        var s1 = base64string
//        s1.removeRange(s1.startIndex..<s1.startIndex.advancedBy(11))
//        //.startIndex.advancedBy(10)
//        //print("imgtype: \(s1)")
//
//        let delim : Character = ";"
//        let index = s1.lowercaseString.characters.indexOf(delim)
//        //print("index: \(index)")
//        let imgType = s1.substringToIndex(index!)
//        //print("imgtype \(imgType)")
//        
//        if imgType == "png" || imgType == "PNG" || imgType == "jpeg" || imgType == "JPEG" || imgType == "gif" || imgType == "GIF"
//        {
//            //print("valid type")
//            return imgType
//        }
//        return "invalid"
//    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("exploreCell", forIndexPath: indexPath) as! ExploreTableViewCell
        
        //get from database
        //coredata
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        let eventEntity = NSEntityDescription.entityForName("Event", inManagedObjectContext: context)
        // Fetch
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = eventEntity
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try context.executeFetchRequest(fetchRequest) as! [Event]
                cell.eventName.text = result[indexPath.row].name
                cell.eventDate.text = result[indexPath.row].getFromDateAsString()
            //if let auser = NSURL(stringby)
            let urlString = result[indexPath.row].poster_url
            if(urlString == "")
            {
                print("poster url is empty")
            }else
            {
                var picString = result[indexPath.row].poster_url!
                //print("HERE: \(result[indexPath.row].poster_url!) HERE2")
                cell.eventImage.image = result[indexPath.row].getImage()

            }
            

            //print(result)
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return cell
    }
 
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
                            aevent.event_id = json["data"][i]["event_id"].intValue
                            //let event_idString = json["data"][i]["event_id"].stringValue
                            aevent.name = json["data"][i]["name"].stringValue
                            aevent.type = json["data"][i]["type"].stringValue
                            aevent.setFromDate(json["data"][i]["from_date"].stringValue)
                            aevent.setToDate(json["data"][i]["to_date"].stringValue)
                            //aevent.venueid //we do not have venueID in core data as it uses . syntax to get related items
                            aevent.desc = json["data"][i]["description"].stringValue
                            aevent.url = json["data"][i]["url"].stringValue
                            //url
                            aevent.requestPoster()
                            print("id: \(aevent.event_id)")
                            print("name: \(aevent.name)")
                            print("type: \(aevent.type)")
                            print("from date:\(aevent.from_date)")
                            print("to date:\(aevent.to_date)")
                            print("desc: \(aevent.desc)")
                            print("url: \(aevent.url)")
                            print("poster: \(aevent.poster_url)")
                            //aevent.tagname
                            
                            
                            self.eventArray.append(aevent);

                        }

                        //save to database
                        do {
                            try context.save()
                        } catch {
                            fatalError("Failure to save context in ExploreViewController: \(error)")
                        }
                        
                        //reload tableview - make sure loading from database not loading from server as we are currently
                        self.EventsTableView.reloadData()
                    }
                case .Failure(let error):
                    print(error)
                    //handle if there is no internet connection by alerting the user
                    
                }
                
            }
            
        }else {
            print("server not set in ExploreViewController")
        }
    }


}
