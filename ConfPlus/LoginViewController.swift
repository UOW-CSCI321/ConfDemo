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
import PKHUD

class LoginViewController: UIViewController {

    @IBOutlet var usernameTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
	
	let user = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.navigationBarHidden = true
		
		user.setObject("https://6f7a5a2d.ngrok.io/api/v1", forKey: "server");
        user.setObject("AHWQQPOAEkUoMjMPGep4za0PVaIOFyKt", forKey: "api_key")
        user.setObject("KsBg70irVEho4FojGBHa301mlsKut0lD", forKey: "app_secret")
    }
    
    func data_request(email : String, pwd : String) {
        if let api_key:String = user.stringForKey("api_key")
        {
            if let app_secret:String = user.stringForKey("app_secret")
            {
                let paramaters = [
                    "method" : "getUser",
                    "email" : email,
                    "api_key" : api_key,
                    "app_secret" : app_secret
                ]
                
                if let URL = user.stringForKey("server")
                {
                    HUD.show(.Progress)
                    
                    Alamofire.request(.POST, URL, parameters: paramaters).responseJSON {response in
                        switch response.result{
                        case .Success:
                            if let value = response.result.value{
                                let json = JSON(value)
                                let password = json["data"][0]["password"].stringValue
                                
                                if(pwd == password){
                                    let username = json["data"][0]["username"].string
                                    let firstName = json["data"][0]["first_name"].string
                                    let lastName = json["data"][0]["last_name"].string
                                    
                                    self.user.setObject(email, forKey: "email")
                                    self.user.setObject(password, forKey: "password")
                                    self.user.setObject(username, forKey: "username")
                                    self.user.setObject(firstName, forKey: "firstName")
                                    self.user.setObject(lastName, forKey: "lastName")
                                    
                                    HUD.hide()
                                    HUD.flash(.Success, delay: 1.0)
                                    self.dismissViewControllerAnimated(true, completion: nil)
                                }else {
                                    HUD.hide()
                                    self.showAlert("Invalid Password")
                                }
                            }
                        case .Failure(let error):
                            HUD.hide()
                            print(error)
                            self.showAlert(error.localizedDescription)
                            
                        }
                        
                    }
                    
                }else {
                    print("server not set in LoginViewController")
                }

            }
            
        }
        
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
