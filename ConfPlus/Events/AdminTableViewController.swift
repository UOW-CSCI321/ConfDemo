//
//  AdminTableViewController.swift
//  confDemo
//
//  Created by Matthew Boroczky on 15/03/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import Foundation
import UIKit
import PKHUD

class AdminTableViewController: UITableViewController {
	
    var event:Event!
	@IBOutlet weak var participantLabel: UILabel!
	@IBOutlet weak var notificationLabel: UILabel!
	@IBOutlet weak var presentationLabel: UILabel!
	@IBOutlet weak var venueLabel: UILabel!
	
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		setText()
		populateNavigationBar()
    }
	
	func setText(){
		navigationItem.title = "Administrations".localized()
		
		participantLabel.text = "Participants".localized()
		notificationLabel.text = "Notification".localized()
		presentationLabel.text = "Presentation".localized()
		venueLabel.text = "Venue & Location".localized()
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let cell:UITableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath.row, inSection: indexPath.section))!
		
		
		switch cell.textLabel!.text! {
			case "Participants".localized():
				performSegueWithIdentifier("goToQRScannerView", sender: self)
		default:
			HUD.flash(.Label("warnFeatures".localized()), delay: 1.0)
		}
	}
	
}

//MARK: Navigation Bar Related
extension AdminTableViewController{
	func populateNavigationBar(){
		self.navigationController?.hidesBarsOnSwipe = true
		
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
	
	func performBackToEvent(){
		dismissViewControllerAnimated(true, completion: nil)
	}
}