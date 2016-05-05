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
	
	
	let MENU_COUNT = 6
	
	@IBAction func exitEventDashboard(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func didSelectView(gesture: UIGestureRecognizer){
		let tag = gesture.view?.tag
		if tag == 6 {
			performBackToEvent()
		} else {
			performSegueWithIdentifier("goToTabView", sender: tag)
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		populateNavigationBar()
		

		// Set the button to rounded edge.
		for index in 1...MENU_COUNT {
			viewEffect.rect(self.view.viewWithTag(index)!)
			self.view.viewWithTag(index)!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HomeViewController.didSelectView(_:))))
		}
    }
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "goToTabView"{
			let vc = segue.destinationViewController as! UITabBarController
			vc.selectedIndex = (sender as! Int) - 1
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
	
	func performBackToEvent(){
		dismissViewControllerAnimated(true){
			self.dismissViewControllerAnimated(true, completion: nil)
		}
	}
}