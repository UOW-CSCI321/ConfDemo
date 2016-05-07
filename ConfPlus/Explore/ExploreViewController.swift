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
        defaults.setObject("https://6f7a5a2d.ngrok.io/api/v1", forKey: "server")
        defaults.setObject("AHWQQPOAEkUoMjMPGep4za0PVaIOFyKt", forKey: "api_key")
        defaults.setObject("KsBg70irVEho4FojGBHa301mlsKut0lD", forKey: "app_secret")
        data_request()
		
		navigationController?.hidesBarsOnSwipe = true
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
            var dstring = result[indexPath.row].getFromDateAsString()
            dstring += " - "
            dstring += result[indexPath.row].getToDateAsString()
            cell.eventDate.text = dstring

            
            //if let auser = NSURL(stringby)
            let urlString = result[indexPath.row].poster_url
            if(urlString == "")
            {
                print("poster url is empty")
            }else
            {
                //var picString = result[indexPath.row].poster_url!
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
        let indexPath:NSIndexPath = self.EventsTableView.indexPathForSelectedRow!
        let eventVC:EventDetailTableViewController = segue.destinationViewController as! EventDetailTableViewController
        //eventVC.descriptionTextView.text =
        eventVC.selectedEvent = eventArray[indexPath.row]
        
    }
    
        
    func data_request()
    {
        //coredata
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        let eventEntity = NSEntityDescription.entityForName("Event", inManagedObjectContext: context)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let api_key:String = defaults.stringForKey("api_key")!
        let app_secret:String = defaults.stringForKey("app_secret")!
        //post request
        let paramaters = [
            "method" : "getEventsByTag",
            "tag_name" : "testTag"
            ,"api_key" : api_key,
             "app_secret" : app_secret
        ] //at the moment the api call need event id
		
        
        
        if let serverAdd = defaults.stringForKey("server")
        {
			
            Alamofire.request(.POST, serverAdd, parameters: paramaters).responseJSON {
                response in switch response.result
                {
                case .Success:
                    if let value = response.result.value
                    {
                        let json = JSON(value)
                        if(json["success"].stringValue == "false")
                        {
                            print("ERROR: message: \(json["message"].stringValue)");
                        }else
                        {
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
                                
                                //                            print("id: \(aevent.event_id)")
                                //                            print("name: \(aevent.name)")
                                //                            print("type: \(aevent.type)")
                                //                            print("from date:\(aevent.from_date)")
                                //                            print("to date:\(aevent.to_date)")
                                //                            print("desc: \(aevent.desc)")
                                //                            print("url: \(aevent.url)")
                                //                            print("poster: \(aevent.poster_url)")
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
                            //self.EventsTableView.reloadData()

                        }
                    }
                    self.EventsTableView.reloadData()
                case .Failure(let error):
                    print(error)
                    self.EventsTableView.reloadData()
                    //handle if there is no internet connection by alerting the user
                }
                
            }
        }else {
            print("server not set in ExploreViewController")
        }
    }


}
