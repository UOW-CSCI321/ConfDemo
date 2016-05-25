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
import PKHUD


class ExploreViewController: UIViewController {
    
    @IBOutlet var EventsTableView: UITableView!
	
	var events = [Event]()
	var isDispatchEmpty:Bool = true
	
	var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
				
		events = ModelHandler().getEvents("0")
		EventsTableView.reloadData()
		
		
		
		refresher = UIRefreshControl()
		refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
		refresher.addTarget(self, action: #selector(self.getEventsFromAPI), forControlEvents: UIControlEvents.ValueChanged)
		self.EventsTableView.addSubview(refresher)
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(true)
		getEventsFromAPI()
	}
	
	func getEventsFromAPI(){
		if isDispatchEmpty {
			isDispatchEmpty = false
			let notification = MPGNotification(title: "Updating", subtitle: "it might takes some time for updating.", backgroundColor: UIColor.orangeColor(), iconImage: nil)
			notification.show()
			
			APIManager().getUpcomingEventsByCountry("Australia"){ result in
				dispatch_async(dispatch_get_main_queue()) {
					notification.hidden = true
					self.isDispatchEmpty = true
					self.events = ModelHandler().getEvents("0")
					self.EventsTableView.reloadData()
					
					if self.refresher.refreshing {
						self.refresher.endRefreshing()
					}
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
		
		if let poster = events[row].poster {
			cell.eventImage.image = UIImage(data: poster)
		} else {
			dispatch_async(dispatch_get_main_queue(), { () -> Void in
				APIManager().getPoster(self.events[row]){ result in
					cell.eventImage.image = self.events[row].getImage()
				}
			})
		}
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let storyboard : UIStoryboard = UIStoryboard(name: "Explore", bundle: nil)
		let vc : EventDetailTableViewController = storyboard.instantiateViewControllerWithIdentifier("EventDetailTableViewController") as! EventDetailTableViewController
		print(events[indexPath.row])
		vc.event = events[indexPath.row]
		
		self.navigationController?.pushViewController(vc, animated: true)
	}
}
