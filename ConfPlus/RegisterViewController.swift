//
//  RegisterViewController.swift
//  ConfPlus
//
//  Created by CY Lim on 29/04/2016.
//  Copyright © 2016 Conf+. All rights reserved.
//

import UIKit
import CryptoSwift
import Localize_Swift

class RegisterViewController: UIViewController {

	@IBOutlet weak var registerButton: UIButton!
	@IBOutlet weak var loginButton: UIButton!
	
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	
	let user = NSUserDefaults.standardUserDefaults()
    let server = APIServer()
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewWillAppear(animated: Bool) {
		setText()
	}
    
	@IBAction func performRegister(sender: AnyObject) {
		guard let username = usernameTextField.text where usernameTextField.text?.characters.count > 0 else {
			showAlert("Invalid Username".localized())
			return
		}
		guard let password = passwordTextField.text where passwordTextField.text?.characters.count > 0 else {
			showAlert("Invalid Password".localized())
			return
		}
		guard let email = emailTextField.text where emailTextField.text?.characters.count > 0 else {
			showAlert("Invalid email".localized())
			return
		}
		
		let hashedPassword = APIServer().hashUserPassword(password)
		
		APIManager().register(email, password: hashedPassword, username: username){ result in
			if result {
				//let email = self.server.hashUserPassword(email)
				self.user.setObject(email, forKey: "email")
				self.user.setObject(username, forKey: "username")
				self.dismissViewControllerAnimated(true, completion: nil)
			} else {
				self.showAlert("warnLogin".localized())
			}
		}
	}

	@IBAction func dismissRegisterView(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func setText(){
		registerButton.setTitle("Register".localized(), forState: .Normal)
		loginButton.setTitle("Login".localized(), forState: .Normal)
		
		usernameTextField.placeholder = "Username".localized()
		emailTextField.placeholder = "Email".localized()
		passwordTextField.placeholder = "Password".localized()
	}
	
	func showAlert(title: String, message:String="warnTryAgain".localized()){
		let alertcontroller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
		let defaultAction = UIAlertAction(title: "OK".localized(), style: .Default, handler: nil)
		alertcontroller.addAction(defaultAction)
		self.presentViewController(alertcontroller, animated: true, completion: nil)
	}
}
