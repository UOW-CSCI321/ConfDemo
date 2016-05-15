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
//        let email = user.stringForKey("email")
        userConversations = ModelHandler().getConversation()
//        let numConvos = userConversations.count
//        if numConvos > 0
//        {
//            for i in 0...(numConvos-1)
//            {
//                var convosMessages = ModelHandler().getMessageForConversation(userConversations[i])
//                if ((convosMessages?.isEmpty) == nil){
//                    print("no messages")
//                }else {
//                    usersMessages.append(convosMessages!)
//                }
//                
//            }
//        }
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
//                    self.usersMessages = [[Message]]() //do a new on it to clear the current data as we are appending - don't want duplicates
//                    let counter = self.userConversations.count
//                    for i in 0...(counter-1)
//                    {
//                        var convosMessages = ModelHandler().getMessageForConversation(self.userConversations[i])
//                        self.usersMessages.append(convosMessages!)
//                    }
                    self.conversationTable.reloadData()
                    print("Reloaded")
                    
                    let notification = MPGNotification(title: "Updated", subtitle: nil, backgroundColor: UIColor.orangeColor(), iconImage: nil)
                    notification.duration = 1
                    notification.show()
                }
            }
        }
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
        //let iv = UIImageView()
        //iv.
        
        
//        cell.usersName.text = "Matthew Steven Boroczky"
//        cell.messageDescription.text = "Hey michael hows everything with project going? go.."
//        cell.messageDateLabel.text = "9:05pm"
        cell.usersName.text = userConversations[row].name //conversation name should be the sender name or if group chat the user sets the name
       // let lastMessage = usersMessages[row].last
        cell.messageDescription.text = userConversations[row].lastmsg_content //lastMessage?.content
        //cell.messageDateLabel.text = lastMessage?.date //put through a function that converst to string and if its the same date says the time else says the day if its within this week else says the date
		
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