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
    @IBOutlet var profilePictureImgView: UIImageView!
    var companyColour1 : UIColor = UIColor(red: 1, green: 165/255, blue: 0, alpha: 1)
	
	var actionSheet: UIAlertController!
	
	let availableLanguages = Localize.availableLanguages()
	
	let user = NSUserDefaults.standardUserDefaults()
    var aUser = User()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

        

        //nameLabel =
        //eventsTableView.reloadData()//reload
		
//core data code save
		/*
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
		

		
		do {
			try context.save()
		} catch {
			fatalError("Failure to save context: \(error)")
		}*/
		
//core data fetch
        /*
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
		*/
        
        //dummy save into nsuserdefaults which will be done on the login screen
//        let defaults = NSUserDefaults.standardUserDefaults()
//        defaults.setObject("matthew", forKey: "firstName")
//        defaults.setObject("boroczky", forKey: "lastName")
//        defaults.setObject("mattattack", forKey: "username")
//        defaults.setObject("mb340@uowmail.edu.au", forKey: "email")
//        defaults.setObject("6f7a5a2d.ngrok.io/api/v1", forKey: "server");
		
        //get
        //let defaults = NSUserDefaults.standardUserDefaults()
		
        
        //code to make a circular profile image
		profilePictureImgView.layer.cornerRadius = profilePictureImgView.frame.size.width/2;
        profilePictureImgView.clipsToBounds = true;
        profilePictureImgView.layer.borderWidth = 3.0
        profilePictureImgView.layer.borderColor = companyColour1.CGColor
        
	}
    
    /*func deleteIncidents(entity:String) {
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
    }*/
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AccountTableViewController.setText), name: LCLLanguageChangeNotification, object: nil)
		
		
		guard let email = user.stringForKey("email") else {
			performLogin() //change to return email
            //aUser = ModelHandler().getUser(email)!
			return
		}
        
//        user.setObject(aUser.first_name, forKey: "firstName")
//        user.setObject(aUser.last_name, forKey: "lastName")
//        user.setObject(aUser.username, forKey: "username")
		
		emailLabel.text = email
		if let name = user.stringForKey("firstName")
		{
			if let name2 = user.stringForKey("lastName")
			{
				nameLabel.text = "\(name) \(name2)"
			}
			
		}
		if let username = user.stringForKey("username")
		{
			usernameLabel.text = username
		}
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
	
	func performLogin(){
		let storyboard : UIStoryboard = UIStoryboard(name: "Account", bundle: nil)
		let vc : LoginViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
		
		let navigationController = UINavigationController(rootViewController: vc)
		
		
		self.presentViewController(navigationController, animated: true, completion: nil)
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
        
        //clear NSUserDefaults
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(NSBundle.mainBundle().bundleIdentifier!)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        performLogin()
	}
	
}