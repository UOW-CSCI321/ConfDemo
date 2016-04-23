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

    @IBOutlet weak var loginView: UIView!
    @IBOutlet var usernameTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        viewEffect.rect(loginView)
        // Do any additional setup after loading the view.
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("6f7a5a2d.ngrok.io/api/v1", forKey: "server");
        
    }
	
	override func viewDidAppear(animated: Bool) {
		//if let defaults = NSUserDefaults.standardUserDefaults()
		let defaults = NSUserDefaults.standardUserDefaults()
		if let _ = defaults.stringForKey("email") {
			if let _ = defaults.stringForKey("password") {
				//segue to next screen automatically
				performSegueWithIdentifier("homeSegue", sender: self)
			}
		}

	}
	

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            Alamofire.request(.POST, "6f7a5a2d.ngrok.io/api/v1", parameters: paramaters).responseJSON {
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
                            self.performSegueWithIdentifier("homeSegue", sender: self)
                        }else {
                            self.showAlert("Invalid Password")
                        }
                    }
                case .Failure(let error):
                    print(error)
                    self.showAlert("Invalid Username")
                    
                }
                
            }
 
        }else {
            print("server not set in LoginViewController")
        }
                //return password;
        
    }
    
    @IBAction func LoginPressed(sender: AnyObject) {
        let username = usernameTextfield.text
        let password = passwordTextfield.text
        data_request(username!, pwd: password!)
        
    }
	
	
	func showAlert(title: String){
		let alertcontroller = UIAlertController(title: title, message: "Please try again", preferredStyle: .Alert)
		let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
		alertcontroller.addAction(defaultAction)
		self.presentViewController(alertcontroller, animated: true, completion: nil)
	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
