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
			dismissViewControllerAnimated(true, completion: nil)
		} else {
			performSegueWithIdentifier("goToTabView", sender: self)
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		// Set the button to rounded edge.
		for index in 1...MENU_COUNT {
			viewEffect.rect(self.view.viewWithTag(index)!)
			self.view.viewWithTag(index)!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HomeViewController.didSelectView(_:))))
		}
    }
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "goToTabView"{
			let vc = segue.destinationViewController as! UITabBarController
			vc.selectedIndex = (sender?.view.tag)! - 1
		}
	}
	
}