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

class AccountTableViewController: UITableViewController {
	
	@IBOutlet weak var languageButton: UIButton!
	@IBOutlet weak var paymentHistoryButton: UIButton!
	@IBOutlet weak var logOutButton: UIButton!
	
	var actionSheet: UIAlertController!
	
	let availableLanguages = Localize.availableLanguages()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AccountTableViewController.setText), name: LCLLanguageChangeNotification, object: nil)
	}
	
	// Remove the LCLLanguageChangeNotification on viewWillDisappear
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	func setText(){
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
	
	// MARK: IBActions
	
	@IBAction func doChangeLanguage(sender: AnyObject) {
		actionSheet = UIAlertController(title: nil, message: "Languages".localized(), preferredStyle: UIAlertControllerStyle.ActionSheet)
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
	
}