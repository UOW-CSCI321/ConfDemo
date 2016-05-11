//
//  RegisterViewController.swift
//  ConfPlus
//
//  Created by CY Lim on 29/04/2016.
//  Copyright © 2016 Conf+. All rights reserved.
//

import UIKit
import CryptoSwift

class RegisterViewController: UIViewController {

	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	
	let user = NSUserDefaults.standardUserDefaults()
    let server = APIServer()
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
	@IBAction func performRegister(sender: AnyObject) {
		guard let username = usernameTextField.text where usernameTextField.text?.characters.count > 0 else {
			showAlert("Invalid Username")
			return
		}
		guard let password = passwordTextField.text where passwordTextField.text?.characters.count > 0 else {
			showAlert("Invalid Password")
			return
		}
		guard let email = emailTextField.text where emailTextField.text?.characters.count > 0 else {
			showAlert("Invalid email")
			return
		}
		
//		let uPassword: [UInt8] = password.utf8.map {$0}
//		let uSalt: [UInt8] = "".utf8.map {$0}
		
		//let value = try! PKCS5.PBKDF2(password: uPassword, salt: uSalt, iterations: 4096, hashVariant: .sha256).calculate()
		
		APIManager().register(email, password: password, username: username){ result in
			if result {
                let email = self.server.hashUserPassword(email)
				self.user.setObject(email, forKey: "email")
				self.user.setObject(username, forKey: "username")
				self.dismissViewControllerAnimated(true, completion: nil)
			} else {
				self.showAlert("Email or Username unavailable.")
			}
		}
	}

	@IBAction func dismissRegisterView(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func showAlert(title: String, message:String="Please try again"){
		let alertcontroller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
		let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
		alertcontroller.addAction(defaultAction)
		self.presentViewController(alertcontroller, animated: true, completion: nil)
	}
}
