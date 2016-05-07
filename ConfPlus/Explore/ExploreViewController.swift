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
		
		events = ModelHandler().getExploreData()
		EventsTableView.reloadData()
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(true)
		
		let group: dispatch_group_t = dispatch_group_create()
		if isDispatchEmpty {
			isDispatchEmpty = false
			let notification = MPGNotification(title: "Updating", subtitle: "it might takes some time for updating.", backgroundColor: UIColor.orangeColor(), iconImage: nil)
			notification.duration = 2
			notification.show()
			
			APIManager().getExploreDataFromAPI(group, isDispatchEmpty: &isDispatchEmpty)
		}
		
		let delay = 4 * Double(NSEC_PER_SEC)
		let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
		dispatch_after(time, dispatch_get_main_queue()) {
			dispatch_group_notify(group, dispatch_get_main_queue()) {
				self.isDispatchEmpty = true
				self.events = ModelHandler().getExploreData()
				self.EventsTableView.reloadData()
				print("Reloaded")
				
				let notification = MPGNotification(title: "Updated", subtitle: nil, backgroundColor: UIColor.orangeColor(), iconImage: nil)
				notification.duration = 1
				notification.show()
			}
		}
	}
	
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath:NSIndexPath = self.EventsTableView.indexPathForSelectedRow!
        let eventVC:EventDetailTableViewController = segue.destinationViewController as! EventDetailTableViewController
        //eventVC.descriptionTextView.text =
        eventVC.selectedEvent = events[indexPath.row]
        
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
		
		var poster = UIImage(named: "matt")
		if (events[row].poster_url != "" || events[row].poster_url != nil) {
			let dataString = events[row].poster_url!
			if let dataString = dataString.componentsSeparatedByString(",").last {
				if let decodedData = NSData(base64EncodedString: dataString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters) {
					poster = UIImage(data: decodedData)
				}
			}
			
			
		}
		cell.eventImage.image = poster
		
		return cell
	}
}
