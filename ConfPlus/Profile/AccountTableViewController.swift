//
//  AccountTableViewController.swift
//  confDemo
//
//  Created by Matthew Boroczky on 15/03/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import Foundation
import UIKit
import Localize_Swift
import CoreData


class AccountTableViewController: UITableViewController {
	
	@IBOutlet weak var editButton: UIBarButtonItem!
	@IBOutlet weak var languageButton: UIButton!
	@IBOutlet weak var paymentHistoryButton: UIButton!
	@IBOutlet weak var logOutButton: UIButton!
	@IBOutlet weak var fixNameLabel: UILabel!
	@IBOutlet weak var fixEmailLabel: UILabel!
	
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
	
	let availableLanguages = Localize.availableLanguages()
	
	let user = NSUserDefaults.standardUserDefaults()
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AccountTableViewController.setText), name: LCLLanguageChangeNotification, object: nil)
		
		
		guard let email = user.stringForKey("email") else {
			performLogin() //change to return email
			return
		}
		emailLabel.text = email
		
		setName()
		
		if nameLabel.text == "Name" {
			APIManager().getUserInformation(email){ result in
				self.setName()
			}
		}		
	}
	
	func setName(){
		if let firstName = self.user.stringForKey("firstName"), lastName = self.user.stringForKey("lastName"){
			self.nameLabel.text = "\(firstName) \(lastName)"
			tableView.reloadData()
		}
	}
	
	// Remove the LCLLanguageChangeNotification on viewWillDisappear
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	func setText(){
		navigationController?.title = "Profile".localized()
		
		navigationItem.title = "Profile".localized()
		
		editButton.title = "Edit".localized()
		fixNameLabel.text = "name".localized()
		fixEmailLabel.text = "email".localized()
		
		languageButton.setTitle("Languages".localized(), forState: .Normal)
		paymentHistoryButton.setTitle("Payment History".localized(), forState: .Normal)
		logOutButton.setTitle("Log Out".localized(), forState: .Normal)
		
		tableView.reloadData()
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return "Profile".localized()
		} else if section == 1 {
			return "Settings".localized()
		}
		return ""
	}
	
	func performLogin(){
		let storyboard : UIStoryboard = UIStoryboard(name: "Account", bundle: nil)
		let vc : LoginViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
		
		let navigationController = UINavigationController(rootViewController: vc)
		
		
		self.presentViewController(navigationController, animated: true, completion: nil)
	}
	
	// MARK: IBActions
	
	@IBAction func doChangeLanguage(sender: AnyObject) {
		let actionSheet = UIAlertController(title: nil, message: "Languages".localized(), preferredStyle: UIAlertControllerStyle.ActionSheet)
		for language in availableLanguages {
			let displayName = Localize.displayNameForLanguage(language)
			let languageAction = UIAlertAction(title: displayName.localized(), style: .Default, handler: {
				(alert: UIAlertAction!) -> Void in
				Localize.setCurrentLanguage(language)
			})
			actionSheet.addAction(languageAction)
		}
		let cancelAction = UIAlertAction(title: "Cancel".localized(), style: UIAlertActionStyle.Cancel, handler: {
			(alert: UIAlertAction) -> Void in
		})
		actionSheet.addAction(cancelAction)
		self.presentViewController(actionSheet, animated: true, completion: nil)
	}
	
	@IBAction func logout(sender: AnyObject) {
        
        //clear NSUserDefaults
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(NSBundle.mainBundle().bundleIdentifier!)
        NSUserDefaults.standardUserDefaults().synchronize()
		
		nameLabel.text = "Name"
        
        performLogin()
	}
	
}