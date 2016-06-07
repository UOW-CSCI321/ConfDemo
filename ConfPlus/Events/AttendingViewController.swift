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
    
    @IBOutlet weak var attendingTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.attendingTableView.delegate = self
        //self.attendingTableView.dataSource = self
		
        getVenue()
		populateNavigationBar()
        
        self.users =  ModelHandler().getUsersForEvent(self.event)!
        self.attendingTableView.reloadData()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //api call to get users for a conversation
        APIManager().getEventAttendeesFromAPI(self.event) { result in
            self.users = ModelHandler().getUsersForEvent(self.event)!
            //for each user in the array try to get their profile pic
            self.attendingTableView.reloadData()
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

//MARK: Table Related
extension AttendingViewController: UITableViewDelegate{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("messageCell", forIndexPath: indexPath) as! MessageTableViewCell
        let row = indexPath.row
        
        var name:String = users[row].first_name!
        name += " "
        name += users[row].last_name!
        cell.usersName.text = name
        
        cell.messageDescription.text = users[row].email!
        cell.messageDateLabel.text = ""
//        if userConversations[row].conversation_pic != nil{
//            cell.profilePicture.image = UIImage(data: userConversations[row].conversation_pic!)
//        }
        
        return cell
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