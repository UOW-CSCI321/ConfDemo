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

	@IBOutlet weak var loginButton: UIButton!
	@IBOutlet weak var registerButton: UIButton!
	@IBOutlet weak var forgotButton: UIButton!
	
    @IBOutlet var usernameTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    let server = APIServer()
	
	let user = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.navigationBarHidden = true
    }
	
	override func viewWillAppear(animated: Bool) {
		
		setText()
		
		if let email = user.stringForKey("email"){
            
			APIManager().getUserInformation(email){ result in
				self.dismissViewControllerAnimated(true, completion: nil)
			}
            
//            if let myself = ModelHandler().getUser(email){
//                APIManager().getUserProfilePicFromAPI(myself) { result in
//                    self.dismissViewControllerAnimated(true, completion: nil)
//                }
//            }
		}
	}
	
    @IBAction func LoginPressed(sender: AnyObject) {
		guard let email = usernameTextfield.text where usernameTextfield.text?.characters.count > 0 else {
			showAlert("Wrong Email".localized())
			return
		}
		guard let password = passwordTextfield.text where passwordTextfield.text?.characters.count > 0 else {
			showAlert("Wrong Password".localized())
			return
		}
		let hashedPassword = APIServer().hashUserPassword(password)
		
		APIManager().login(email, password: hashedPassword){ result in
			if result {
				//let email = self.server.hashUserPassword(email)
				self.user.setObject(email, forKey: "email")
                //if login successful get the user from database
                //let myself = ModelHandler().getUser(email)
                
				//self.dismissViewControllerAnimated(true, completion: nil)
                APIManager().getUserInformation(email){ result in
                    if let myself = ModelHandler().getUser(email) {
                        APIManager().getUserProfilePicFromAPI(myself) { result in
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }

                    }
                    //self.dismissViewControllerAnimated(true, completion: nil)
                }


			} else {
				self.showAlert("warnLogin".localized())
			}
		}
		
    }
	
	func setText(){
		loginButton.setTitle("Login".localized(), forState: .Normal)
		registerButton.setTitle("Register".localized(), forState: .Normal)
		forgotButton.setTitle("Forgot Password".localized(), forState: .Normal)
		
		usernameTextfield.placeholder = "Email".localized()
		passwordTextfield.placeholder = "Password".localized()
	}
	
	func showAlert(title: String, message:String="warnTryAgain".localized()){
		let alertcontroller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
		let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
		alertcontroller.addAction(defaultAction)
		self.presentViewController(alertcontroller, animated: true, completion: nil)
	}

}
