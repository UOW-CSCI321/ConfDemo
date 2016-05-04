//
//  LoginViewController.swift
//  confDemo
//
//  Created by CY Lim on 2015/10/08.
//  Copyright © 2015年 CY Lim. All rights reserved.
//

import UIKit
import Localize_Swift
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {

    @IBOutlet var usernameTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func data_request(email : String, pwd : String) /*-> String*/
    {
        let paramaters = [
            "method" : "getUser",
            "email" : email
        ]
        
        let defaults = NSUserDefaults.standardUserDefaults()
		if let serverAdd = defaults.stringForKey("server")
        {
            Alamofire.request(.POST, serverAdd, parameters: paramaters).responseJSON {
                response in switch response.result
                {
                case .Success:
                    if let value = response.result.value
                    {
                        let json = JSON(value)
                        let password = json["data"][0]["password"].stringValue //data[0].password
                        
                        if(pwd == password)
                        {
                            //logged in
                            let defaults = NSUserDefaults.standardUserDefaults()
                            defaults.setObject(password, forKey: "password")
                            defaults.setObject(email, forKey: "email")
							//self.performSegueWithIdentifier("homeSegue", sender: self)
							self.dismissViewControllerAnimated(true, completion: nil)
                        }else {
                            self.showAlert("Invalid Password")
                        }
                    }
                case .Failure(let error):
                    print(error)
                    //print("error code: \(error.localizedDescription)")
                    self.showAlert(error.localizedDescription)
                    
                }
                
            }
 
        }else {
            print("server not set in LoginViewController")
        }
                //return password;
        
    }
    
    @IBAction func LoginPressed(sender: AnyObject) {
		guard let username = usernameTextfield.text where usernameTextfield.text?.characters.count > 0 else {
			showAlert("Wrong Username")
			return
		}
		guard let password = passwordTextfield.text where passwordTextfield.text?.characters.count > 0 else {
			showAlert("Wrong Password")
			return
		}
        data_request(username, pwd: password)
        
    }
	
	
	func showAlert(title: String, message:String="Please try again"){
		let alertcontroller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
		let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
		alertcontroller.addAction(defaultAction)
		self.presentViewController(alertcontroller, animated: true, completion: nil)
	}

}
