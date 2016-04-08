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
	
	@IBOutlet weak var languageButton: UIButton!
	@IBOutlet weak var paymentHistoryButton: UIButton!
	@IBOutlet weak var logOutButton: UIButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
	
	var actionSheet: UIAlertController!
	
	let availableLanguages = Localize.availableLanguages()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
        //get from coredata
//        var request = NSFetchRequest(entityName: "User")
//        request.returnsObjectsAsFaults = false;
		//var results:NSArray = context.executeFetchRequest
		
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let context = appDelegate.managedObjectContext
		
		let userEntity = NSEntityDescription.entityForName("User", inManagedObjectContext: context)
		
		
		// Save
		let user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: context) as! User
        user.username = "matts_test_username"
        user.password = "matts_test_password"
        user.first_name = "first_name_test"
        user.last_name = "last_name_test"
        user.email = "email_test"
		

		//user.setValue("username", forKey: "username")
//		user.setValue("upgraded", forKey: "upgraded")
//		user.setValue("title", forKey: "title")
//		user.setValue("street", forKey: "street")
//		user.setValue("state", forKey: "state")
		//user.setValue("password", forKey: "password")
//		user.setValue("linkedin_id", forKey: "linkedin_id")
//		user.setValue("last_name", forKey: "last_name")
//		user.setValue("first_name", forKey: "first_name")
//		user.setValue("fb_id", forKey: "fb_id");
//		user.setValue("email_verified", forKey: "email_verified")
//		user.setValue("email", forKey: "email")
//		user.setValue("dob", forKey: "dob")
//		user.setValue("country", forKey: "country")
//		user.setValue("city", forKey: "city")
//		user.setValue("active", forKey: "active")
		
		do {
			try context.save()
		} catch {
			fatalError("Failure to save context: \(error)")
		}
		
		
		// Fetch
		let fetchRequest = NSFetchRequest()
		fetchRequest.entity = userEntity
        fetchRequest.returnsObjectsAsFaults = false
		
		do {
			let result = try context.executeFetchRequest(fetchRequest) as! [User]
            
            if(result.count > 1)
            {
                print("error should only have retrieved one record. retrieved \(result.count)")
                //lets try to delete the data
                /*let deleterequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                do { try context.executeFetchRequest(deleterequest)}
                catch let error as NSError { debugPrint(error) }*/
                
                deleteIncidents("User")
                
                print(result)
            } else {
                let fname = result[0].first_name
                let lname = result[0].last_name
                var name = fname! + " "
                name += lname!
                print("name")
                print(name)
                
                nameLabel.text = name
                usernameLabel.text = result[0].username
                
                
                var val = ""
                if((result[0].email_verified) != nil)
                {
                    val = "(validated)"
                }else {
                    val = "(not validated)"
                }
                if let email = result[0].email{
                    emailLabel.text = "\(email) \(val)"
                }
                
            }
            print(result)
		} catch {
			let fetchError = error as NSError
			print(fetchError)
		}
		
        
        
	}
    
    func deleteIncidents(entity:String) {
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDel.managedObjectContext
        let coord = appDel.persistentStoreCoordinator
        
        let fetchRequest = NSFetchRequest(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coord.executeRequest(deleteRequest, withContext: context)
        } catch let error as NSError {
            debugPrint(error)
        }
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
	
	@IBAction func logout(sender: AnyObject) {
		self.performSegueWithIdentifier("goToLogin", sender: self)		
	}

	
}