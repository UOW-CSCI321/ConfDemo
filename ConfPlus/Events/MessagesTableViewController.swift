//
//  MessagesTableViewController.swift
//  confDemo
//
//  Created by Matthew Boroczky on 15/03/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import Foundation
import UIKit

class MessagesTableViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		populateNavigationBar()
    }
	
}

extension MessagesTableViewController: UITableViewDelegate{
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
        var onlineColour : UIColor = UIColor(red: 0.42, green: 0.92, blue: 0.04, alpha: 1)
        var offlineColour : UIColor = UIColor(red: 0.99, green: 0.29, blue: 0.01, alpha: 1)
        
        let cell = tableView.dequeueReusableCellWithIdentifier("messageCell", forIndexPath: indexPath) as! MessageTableViewCell
        //let iv = UIImageView()
        //iv.
        cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.size.width/2
        cell.profilePicture.clipsToBounds = true
        cell.profilePicture.layer.borderWidth = 3.0
        cell.profilePicture.layer.borderColor = onlineColour.CGColor
        //cell.imageView = cell.imageView?.frame.size.width/2;
        //profilePictureImgView.layer.cornerRadius = profilePictureImgView.frame.size.width/2;
//        profilePictureImgView.clipsToBounds = true;
//        profilePictureImgView.layer.borderWidth = 3.0
//        profilePictureImgView.layer.borderColor = companyColour1.CGColor
		
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