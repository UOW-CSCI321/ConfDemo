//
//  AttendingViewController.swift
//  confDemo
//
//  Created by Matthew Boroczky on 15/03/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import Foundation
import UIKit

class AttendingViewController: UIViewController {
    var event:Event!
    var users = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
		
        getVenue()
		populateNavigationBar()
        
        self.users =  ModelHandler().getUsersForEvent(self.event)!
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //api call to get users for a conversation
        APIManager().getEventAttendeesFromAPI(self.event) { result in
            self.users = ModelHandler().getUsersForEvent(self.event)!
        }
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

//MARK: Navigation Bar Related
extension AttendingViewController{
	func populateNavigationBar(){		
		let contact = UIBarButtonItem(image: UIImage(named: "security32"), style: .Plain, target: self, action: #selector(performSecurityView))
		let location = UIBarButtonItem(image: UIImage(named: "second"), style: .Plain, target: self, action: #selector(performLocationView))
		
		let space = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: self, action: nil)
		
		let buttons = [contact, space, location]
		
		self.navigationItem.setRightBarButtonItems(buttons, animated: true)
	}
	
	func performSecurityView(){
		let storyboard : UIStoryboard = UIStoryboard(name: "EventAssistServices", bundle: nil)
		let vc : SecurityViewController = storyboard.instantiateViewControllerWithIdentifier("SecurityViewController") as! SecurityViewController
        vc.event = self.event
		let navigationController = UINavigationController(rootViewController: vc)
    
		self.presentViewController(navigationController, animated: true, completion: nil)
	}
	
	func performLocationView(){
		let storyboard : UIStoryboard = UIStoryboard(name: "EventAssistServices", bundle: nil)
		let vc : EventLocationViewController = storyboard.instantiateViewControllerWithIdentifier("EventLocationViewController") as! EventLocationViewController
		vc.event = self.event
		let navigationController = UINavigationController(rootViewController: vc)
		
		self.presentViewController(navigationController, animated: true, completion: nil)
	}
}