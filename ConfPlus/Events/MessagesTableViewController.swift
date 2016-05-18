//
//  MessagesTableViewController.swift
//  confDemo
//
//  Created by Matthew Boroczky on 15/03/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import Foundation
import UIKit
import MPGNotification


class MessagesTableViewController: UIViewController {
    
    @IBOutlet var conversationTable: UITableView!
    
    //var usersMessages = [[Message]]()
    var userConversations = [Conversation]()
    var isDispatchEmpty:Bool = true
    
    let user = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		populateNavigationBar()
        userConversations = ModelHandler().getConversation()
        conversationTable.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let email = user.stringForKey("email")
        
        if isDispatchEmpty {
            let group: dispatch_group_t = dispatch_group_create()
            isDispatchEmpty = false
            let notification = MPGNotification(title: "Updating", subtitle: "it might takes some time for updating.", backgroundColor: UIColor.orangeColor(), iconImage: nil)
            notification.duration = 2
            notification.show()
            
            APIManager().getConversationsFromAPI(email!, group: group, isDispatchEmpty: &isDispatchEmpty){ result in
                dispatch_group_notify(group, dispatch_get_main_queue()) {
                    self.isDispatchEmpty = true
                    self.userConversations = ModelHandler().getConversation()

                    self.conversationTable.reloadData()
                    print("Reloaded")
                    
                    let notification = MPGNotification(title: "Updated", subtitle: nil, backgroundColor: UIColor.orangeColor(), iconImage: nil)
                    notification.duration = 1
                    notification.show()
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath:NSIndexPath = self.conversationTable.indexPathForSelectedRow!
        let messengerVC:MessengerViewController = segue.destinationViewController as! MessengerViewController
        messengerVC.conversationID = userConversations[indexPath.row].conversation_id!
        messengerVC.senderId = user.stringForKey("email")
        messengerVC.title = userConversations[indexPath.row].name
        messengerVC.senderDisplayName = userConversations[indexPath.row].lastmsg_email
        self.hidesBottomBarWhenPushed = true //need to hide tab bar to show message bar at the bottom. i tried to move message bar in JSQMessagesViewController but it has some action on it that when clicked it will move back down
    }
    

	
}

extension MessagesTableViewController: UITableViewDelegate{
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return userConversations.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("messageCell", forIndexPath: indexPath) as! MessageTableViewCell
        let row = indexPath.row
        
        
//        cell.usersName.text = "Matthew Steven Boroczky"
//        cell.messageDescription.text = "Hey michael hows everything with project going? go.."
//        cell.messageDateLabel.text = "9:05pm"
        
        cell.usersName.text = userConversations[row].name //conversation name should be the sender
        cell.messageDescription.text = userConversations[row].lastmsg_content //lastMessage?.content
        cell.messageDateLabel.text = userConversations[row].getConversationDateAsString()
		
		return cell
	}
}

//MARK: Navigation Bar Related
extension MessagesTableViewController{
	func populateNavigationBar(){
		self.navigationController?.hidesBarsOnSwipe = true
		
		let contact = UIBarButtonItem(image: UIImage(named: "security32"), style: .Plain, target: self, action: #selector(performSecurityView))
		let location = UIBarButtonItem(image: UIImage(named: "second"), style: .Plain, target: self, action: #selector(performLocationView))
		let cancel = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(performBackToEvent))
		
		let space = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: self, action: nil)
		
		let buttons = [contact, space, location]
		
		self.navigationItem.setRightBarButtonItems(buttons, animated: true)
		self.navigationItem.setLeftBarButtonItem(cancel, animated: true)
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
	
	func performBackToEvent(){
		dismissViewControllerAnimated(true, completion: nil)
	}
}