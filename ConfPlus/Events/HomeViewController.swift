//
//  HomeViewController.swift
//  confDemo
//
//  Created by Matthew Boroczky on 15/03/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var eventName: UILabel!
	@IBOutlet weak var eventDate: UILabel!
	@IBOutlet weak var eventLocation: UITextView!
	
	var features = ["Timetable", "Participants", "Tickets", "Message"]
	var event:Event!
	
	let user = NSUserDefaults.standardUserDefaults()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		populateEventOverview()
		populateNavigationBar()
        
        getVenue()
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(true)
		
		if let role = user.stringForKey("role"){
			if role == "Admin" {
				features.append("Administration")
				tableView.reloadData()
			}
		}
	}
	
	@IBAction func performBack(sender: AnyObject) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func populateEventOverview(){
		eventName.text = event.name
		eventDate.text = "\(event.getFromDateAsString()) - \(event.getToDateAsString())"
		//eventLocation.text = "\(event.venue?.city), \(event.venue?.country)"
	}
    
    func getVenue()
    {
        APIManager().getVenue(self.event){ result in
             if let eventsVenue = ModelHandler().getVenueByEvent(self.event)
             {
                APIManager().getMapForVenue(eventsVenue) { result in
                    //successfully have the venue map
                }
             }
        }
    }
}

extension HomeViewController: UITableViewDelegate {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return features.count
	}
	
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("featureCell", forIndexPath: indexPath)
		
		let row = indexPath.row
		
		cell.textLabel!.text = features[row]
		cell.imageView?.image = UIImage(named: features[row])
		
		return cell
	}
	
		func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
			let row = indexPath.row
			
			switch features[row] {
				case "Timetable":
					self.performSegueWithIdentifier("goToTimetable", sender: self)
				case "Participants":
					self.performSegueWithIdentifier("goToParticipants", sender: self)
				case "Tickets":
					self.performSegueWithIdentifier("goToTickets", sender: self)
				case "Message":
					self.performSegueWithIdentifier("goToMessages", sender: self)
				case "Administrations":
					self.performSegueWithIdentifier("goToAdministrations", sender: self)
				default:
					()
			}
		}
}

//MARK: Navigation Bar Related
extension HomeViewController{
	func populateNavigationBar(){
		self.navigationController?.hidesBarsOnSwipe = true
		
		let contact = UIBarButtonItem(image: UIImage(named: "security32"), style: .Plain, target: self, action: #selector(performSecurityView))
		let location = UIBarButtonItem(image: UIImage(named: "second"), style: .Plain, target: self, action: #selector(performLocationView))
		
		let space = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: self, action: nil)
		
		let buttons = [contact, space, location]
		
		self.navigationItem.setRightBarButtonItems(buttons, animated: true)
	}
	
	func performSecurityView(){
		let storyboard : UIStoryboard = UIStoryboard(name: "EventAssistServices", bundle: nil)
		let vc : SecurityViewController = storyboard.instantiateViewControllerWithIdentifier("SecurityViewController") as! SecurityViewController
		
		let navigationController = UINavigationController(rootViewController: vc)
		
		self.presentViewController(navigationController, animated: true, completion: nil)
	}
	
	func performLocationView(){
		let storyboard : UIStoryboard = UIStoryboard(name: "EventAssistServices", bundle: nil)
		let vc : EventLocationViewController = storyboard.instantiateViewControllerWithIdentifier("EventLocationViewController") as! EventLocationViewController
		
		let navigationController = UINavigationController(rootViewController: vc)
		
		self.presentViewController(navigationController, animated: true, completion: nil)
	}
}