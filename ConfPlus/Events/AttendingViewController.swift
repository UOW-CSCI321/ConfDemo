//
//  AttendingViewController.swift
//  confDemo
//
//  Created by Matthew Boroczky on 15/03/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import Foundation
import UIKit
import MPGNotification
import MessageUI

class AttendingViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    var event:Event!
    var users = [User]()
    
    @IBOutlet weak var attendingTableView: UITableView!
    
    @IBOutlet weak var inviteTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		navigationItem.title = "Participants".localized()
//		let inviteDelegate = InviteTable()
//        inviteTableView.delegate = inviteDelegate
		
        getVenue()
		populateNavigationBar()
        
        self.users =  ModelHandler().getUsersForEvent(self.event)!
        //self.attendingTableView.reloadData()
        self.attendingTableView.reloadData()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //api call to get users for a conversation
        let notification = MPGNotification(title: "Updating".localized(), subtitle: "warnUpdateMessage".localized(), backgroundColor: UIColor.orangeColor(), iconImage: nil)
        notification.duration = 60
        notification.show()
        APIManager().getEventAttendeesFromAPI(self.event) { result in
			notification.dismissWithAnimation(true)
            self.users = ModelHandler().getUsersForEvent(self.event)!
            notification.dismissWithAnimation(true)
            //print(self.users)
            //self.attendingTableView.reloadData()
            
        }
    }
    
    //MARK: SMS
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        switch result.rawValue {
        case MessageComposeResultCancelled.rawValue :
            print("message canceled")
            
        case MessageComposeResultFailed.rawValue :
            print("message failed")
            
        case MessageComposeResultSent.rawValue :
            print("message sent")
            
        default:
            break
        }
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func sendMessage() {
        let messageVC = MFMessageComposeViewController()
        
        var content = "Hey! i'm attending "
        content += self.event.name!
        content += ", i have a feeling you'll like this event. check it out at http://www.eventure.management/events/"
        content += self.event.event_id!
        messageVC.body = content
        
        //messageVC.recipients
        messageVC.messageComposeDelegate = self
        if MFMessageComposeViewController.canSendText() {
            presentViewController(messageVC, animated: true, completion: nil)
        }
    }
    
    //MARK: Venue
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
		if tableView == attendingTableView {
			return users.count
		} else {
			return 3
		}
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if tableView == attendingTableView {
			let cell = tableView.dequeueReusableCellWithIdentifier("messageCell", forIndexPath: indexPath) as! MessageTableViewCell
			let row = indexPath.row
			
			var name:String = users[row].first_name!
			name += " "
			name += users[row].last_name!
			cell.usersName.text = name
			
			if let username = users[row].username {
				cell.messageDescription.text = username
			}else {
				cell.messageDescription.text = users[row].email!
			}
			
			cell.messageDateLabel.text = ""
			if users[row].profile_pic_url != nil {
				cell.profilePicture.image = users[row].getImage()
			}else{
				cell.profilePicture.image = UIImage(named: "logo_blue")
			}
			
			return cell
		} else {
			let cell = tableView.dequeueReusableCellWithIdentifier("inviteTableViewCell", forIndexPath: indexPath) as! inviteTableViewCell
			let row = indexPath.row
			
			var message = "Invite".localized()
            if row == 0{
                cell.inviteLabel.text = "\(message) Contacts"
                cell.inviteImageView.image = UIImage(named: "contacts")
                
            }else if row == 1 {
                cell.inviteLabel.text = "\(message) Facebook"
                cell.inviteImageView.image = UIImage(named: "FB-f-Logo__blue_50")
            }else if row == 2 {
                cell.inviteLabel.text = "\(message) LinkedIn"
                cell.inviteImageView.image = UIImage(named: "linkedin")
            }else {
                cell.inviteLabel.text = ""
                cell.inviteImageView = nil
            }
            cell.backgroundColor = UIColor(red: 0.94, green: 0.90, blue: 0.90, alpha: 0.5)
			
			return cell
		}
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == inviteTableView{
            if indexPath.row == 0{
                self.sendMessage()
            }
        }
    }
}


//MARK: Navigation Bar Related
extension AttendingViewController{
	func populateNavigationBar(){
		let contact = UIBarButtonItem(image: UIImage(named: "security32"), style: .Plain, target: self, action: #selector(performSecurityView))
		let location = UIBarButtonItem(image: UIImage(named: "map"), style: .Plain, target: self, action: #selector(performLocationView))
		
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