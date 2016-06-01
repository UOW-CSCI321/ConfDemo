//
//  ExploreViewController.swift
//  confDemo
//
//  Created by CY Lim on 2015/10/08.
//  Copyright © 2015年 CY Lim. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import MPGNotification


class EventsViewController: UIViewController {
	
	@IBOutlet var tableView: UITableView!
	
	var events = [Event]()
	var criteria = "future"
	var isDispatchEmpty:Bool = true
	
	var refresher: UIRefreshControl!
	
	let user = NSUserDefaults.standardUserDefaults()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if criteria == "past"{
			events = ModelHandler().getEvents("1", future: false)
			tableView.reloadData()
		} else {
			events = ModelHandler().getEvents("1")
			tableView.reloadData()
		}
		
		refresher = UIRefreshControl()
		refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
		refresher.addTarget(self, action: #selector(self.getEventsFromAPI), forControlEvents: UIControlEvents.ValueChanged)
		self.tableView.addSubview(refresher)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(true)
		getEventsFromAPI()
	}
	
	@IBAction func selectEventCriteria(sender: UISegmentedControl) {
		if sender.selectedSegmentIndex == 0 {
			criteria = "future"
		} else {
			criteria = "past"
		}
		getEventsFromAPI()
	}
	
	func getEventsFromAPI(){
		guard let email = user.stringForKey("email") else {
			performLogin()
			return
		}
		
		if isDispatchEmpty {
			isDispatchEmpty = false
			
			APIManager().getEventsAttending(email, criteria: criteria){ result in
				dispatch_async(dispatch_get_main_queue()) {
					self.isDispatchEmpty = true
					if self.criteria == "past"{
						self.events = ModelHandler().getEvents("1", future: false)
						self.tableView.reloadData()
					} else {
						self.events = ModelHandler().getEvents("1")
						self.tableView.reloadData()
					}
					
					if self.refresher.refreshing {
						self.refresher.endRefreshing()
						
					}
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
}


//MARK: TableView Related
extension EventsViewController: UITableViewDelegate{
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return events.count
	}
	
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("eventCell", forIndexPath: indexPath) as! EventsTableViewCell
		
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
		let storyboard : UIStoryboard = UIStoryboard(name: "Event", bundle: nil)
		let vc : HomeViewController = storyboard.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
		
		vc.event = events[indexPath.row]
		
		let navigationController = UINavigationController(rootViewController: vc)
		
		self.presentViewController(navigationController, animated: true, completion: nil)
	}
}
