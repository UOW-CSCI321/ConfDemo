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
import MPGNotification


class ExploreViewController: UIViewController {
    
    @IBOutlet var EventsTableView: UITableView!
	
	var events = [Event]()
	var isDispatchEmpty:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		navigationController?.hidesBarsOnSwipe = true
		
		events = ModelHandler().getEvents("0")
		EventsTableView.reloadData()
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(true)
		
		if isDispatchEmpty {
			isDispatchEmpty = false
			let notification = MPGNotification(title: "Updating", subtitle: "it might takes some time for updating.", backgroundColor: UIColor.orangeColor(), iconImage: nil)
			notification.show()
			
			APIManager().getExploreDataFromAPI(){ result in
				dispatch_async(dispatch_get_main_queue()) {
					notification.hidden = true
					self.isDispatchEmpty = true
					self.events = ModelHandler().getEvents("0")
					self.EventsTableView.reloadData()
					print("Reloaded")
				}
			}
		}
	}
	
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath:NSIndexPath = self.EventsTableView.indexPathForSelectedRow!
        let eventVC:EventDetailTableViewController = segue.destinationViewController as! EventDetailTableViewController
			eventVC.event = events[indexPath.row]
    }
	
}


//MARK: TableView Related
extension ExploreViewController: UITableViewDelegate{
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return events.count
	}
	
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("exploreCell", forIndexPath: indexPath) as! ExploreTableViewCell
		
		let row = indexPath.row
		
		cell.eventName.text = events[row].name
		
		let date = "\(events[row].getFromDateAsString()) - \(events[row].getToDateAsString())"
		cell.eventDate.text = date
		
		dispatch_async(dispatch_get_main_queue(), { () -> Void in
			if self.events[row].poster_url != nil {
				cell.eventImage.image = self.events[row].getImage()
			} else {
				APIManager().getPoster(self.events[row]){ result in
					cell.eventImage.image = self.events[row].getImage()
				}
			}
		})
		
		
		return cell
	}
}
