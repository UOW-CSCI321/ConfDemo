//
//  EventTableViewController.swift
//  ConfPlus
//
//  Created by CY Lim on 19/03/2016.
//  Copyright © 2016 Conf+. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class EventsViewController: UIViewController, UITableViewDelegate {
    
    var eventAttendedArray = [Event]()
	let user = NSUserDefaults.standardUserDefaults()
	
    @IBOutlet var eventsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data_request()
		
		navigationController?.hidesBarsOnSwipe = true
    }

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		guard let _ = user.stringForKey("email") else {
			performLogin()
			return
		}
	}
	
	func performLogin(){
		let storyboard : UIStoryboard = UIStoryboard(name: "Account", bundle: nil)
		let vc : LoginViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
		
		let navigationController = UINavigationController(rootViewController: vc)
		
		self.presentViewController(navigationController, animated: true, completion: nil)
	}

    // MARK: - Table view data source

	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 1
         return eventAttendedArray.count
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
                            aevent.name = json["data"][i]["name"].stringValue
                            aevent.type = json["data"][i]["type"].stringValue
                            aevent.setFromDate(json["data"][i]["from_date"].stringValue)
                            aevent.setToDate(json["data"][i]["to_date"].stringValue)
                            //aevent.venueid //we do not have venueID in core data as it uses . syntax to get related items
                            aevent.desc = json["data"][i]["description"].stringValue
                            aevent.url = json["data"][i]["url"].stringValue
                            aevent.requestPoster()
                            
//                            print("id: \(aevent.event_id)")
//                            print("name: \(aevent.name)")
//                            print("type: \(aevent.type)")
//                            print("from date:\(aevent.from_date)")
//                            print("to date:\(aevent.to_date)")
//                            print("desc: \(aevent.desc)")
//                            print("url: \(aevent.url)")
//                            print("poster: \(aevent.poster_url)")
                            
                            self.eventAttendedArray.append(aevent);
                            
                        }
                        //clear current data in the database
                        
                        //save to database
                        do {
                            try context.save()
                        } catch {
                            fatalError("Failure to save context in ExploreViewController: \(error)")
                        }

                        self.eventsTableView.reloadData()
                        
                    }
                case .Failure(let error):
                    print(error)
                    //handle if there is no internet connection
                    
                }
                
            }
            
        }else {
            print("server not set in LoginViewController")
        }
    }

	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("eventCell", forIndexPath: indexPath) as! EventTableViewCell

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
            cell.eventImage.image = result[indexPath.row].getImage()
            
            //print(result)
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return cell
    }
	

}
