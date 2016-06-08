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
import Localize_Swift


class ExploreViewController: UIViewController {
    
    @IBOutlet var EventsTableView: UITableView!
	
	var events = [Event]()
	var isDispatchEmpty:Bool = true
	
	var refresher: UIRefreshControl!
	var notification: MPGNotification!
    
    override func viewDidLoad() {
        super.viewDidLoad()
				
		events = ModelHandler().getEvents("0")
		EventsTableView.reloadData()
		
		refresher = UIRefreshControl()
		refresher.attributedTitle = NSAttributedString(string: "Pull to refresh".localized())
		refresher.addTarget(self, action: #selector(self.getEventsFromAPI), forControlEvents: UIControlEvents.ValueChanged)
		self.EventsTableView.addSubview(refresher)
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(true)
        
        let user = NSUserDefaults.standardUserDefaults()
        let hasOnboard = "true"
        user.setObject(hasOnboard, forKey: "hasOnboard")
        
		setText()
		getEventsFromAPI()
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		
		notification.dismissWithAnimation(true)
	}
	
	func setText(){
		navigationItem.title = "Explore".localized()
		navigationController?.title = "Explore".localized()
	}
	
	func getEventsFromAPI(){
		if isDispatchEmpty {
			isDispatchEmpty = false
			notification = MPGNotification(title: "Updating".localized(), subtitle: "warnUpdateMessage".localized(), backgroundColor: UIColor.orangeColor(), iconImage: nil)
			notification.show()
			
			APIManager().getUpcomingEventsByCountry("Australia"){ result in
				dispatch_async(dispatch_get_main_queue()) {
					self.notification.dismissWithAnimation(true)
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
			cell.eventImage.image = UIImage(named: "event_placeholder")
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
		vc.event = events[indexPath.row]
		
		self.navigationController?.pushViewController(vc, animated: true)
	}
}
