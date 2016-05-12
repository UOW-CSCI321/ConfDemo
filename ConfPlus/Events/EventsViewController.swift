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
import MPGNotification

class EventsViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet var eventsTableView: UITableView!
    var eventAttendedArray = [Event]()
    var isDispatchEmpty:Bool = true
    
	let user = NSUserDefaults.standardUserDefaults()
	
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //data_request()
		
		navigationController?.hidesBarsOnSwipe = true
        eventAttendedArray = ModelHandler().getEvents("1") //get attending
        eventsTableView.reloadData()//reload
    }

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		guard let _ = user.stringForKey("email") else {
			performLogin()
			return
		}
        
        if isDispatchEmpty {
            let group: dispatch_group_t = dispatch_group_create()
            isDispatchEmpty = false
            let notification = MPGNotification(title: "Updating", subtitle: "it might takes some time for updating.", backgroundColor: UIColor.orangeColor(), iconImage: nil)
            notification.duration = 2
            notification.show()
            
            APIManager().getMyEventDataFromAPI(group, isDispatchEmpty: &isDispatchEmpty){ result in
                dispatch_group_notify(group, dispatch_get_main_queue()) {
                    self.isDispatchEmpty = true
                    self.eventAttendedArray = ModelHandler().getEvents("1")
                    self.eventsTableView.reloadData()
                    print("Reloaded")
                    
                    let notification = MPGNotification(title: "Updated", subtitle: nil, backgroundColor: UIColor.orangeColor(), iconImage: nil)
                    notification.duration = 1
                    notification.show()
                }
            }
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
         return eventAttendedArray.count
    }

	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("eventCell", forIndexPath: indexPath) as! EventTableViewCell
        let row = indexPath.row
        
        cell.eventName.text = eventAttendedArray[row].name
        
        let date = "\(eventAttendedArray[row].getFromDateAsString()) - \(eventAttendedArray[row].getToDateAsString())"
        cell.eventDate.text = date
        
        cell.eventImage.image = eventAttendedArray[row].getImage()
        
        return cell
    }
	

}
