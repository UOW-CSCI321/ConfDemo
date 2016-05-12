//
//  LoginViewController.swift
//  confDemo
//
//  Created by CY Lim on 2015/10/08.
//  Copyright © 2015年 CY Lim. All rights reserved.
//

import UIKit
import Localize_Swift
import CryptoSwift

class LoginViewController: UIViewController {

    @IBOutlet var usernameTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    let server = APIServer()
	
	let user = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.navigationBarHidden = true
    }
	
	override func viewWillAppear(animated: Bool) {
		if let email = user.stringForKey("email"){
			APIManager().getUserInformation(email){ result, data in
				
				self.dismissViewControllerAnimated(true, completion: nil)
			}
			
		}
	}
	
    @IBAction func LoginPressed(sender: AnyObject) {
		guard let email = usernameTextfield.text where usernameTextfield.text?.characters.count > 0 else {
			showAlert("Wrong Email")
			return
		}
		guard let password = passwordTextfield.text where passwordTextfield.text?.characters.count > 0 else {
			showAlert("Wrong Password")
			return
		}
		let hashedPassword = APIServer().hashUserPassword(password)
		
		APIManager().login(email, password: hashedPassword){ result in
			if result {
				//let email = self.server.hashUserPassword(email)
				self.user.setObject(email, forKey: "email")
				self.dismissViewControllerAnimated(true, completion: nil)
			} else {
				self.showAlert("Incorrect Email or Password")
			}
		}
		
    }
	
	
	func showAlert(title: String, message:String="Please try again"){
		let alertcontroller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
		let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
		alertcontroller.addAction(defaultAction)
		self.presentViewController(alertcontroller, animated: true, completion: nil)
	}

}
