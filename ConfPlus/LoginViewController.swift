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
        
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func data_request(email : String) -> String
    {
        let paramaters = [
            "method" : "getUser",
            "email" : email
        ]
        
        var password = "error"
        
        Alamofire.request(.POST, "https://b0d1d301.ngrok.io/api/v1", parameters: paramaters).responseJSON {
            response in switch response.result
            {
                case .Success:
                    if let value = response.result.value
                    {
                        let json = JSON(value)
                        let data = json["data"][0]["password"] //data[0].password
                        //print("data: \(data)")
                        password = data.stringValue
                        //print("password: \(password)")
                    }
                case .Failure(let error):
                    print(error)
            
            }
            
        }
        return password;
        
    }
    
    @IBAction func LoginPressed(sender: AnyObject) {
        let username = usernameTextfield.text
        let password = passwordTextfield.text
        let real_pwd = data_request(username!)
       
        if(real_pwd == password)
        {
            //logged in
        }else {
            let alertcontroller = UIAlertController(title: "invalid username or password", message: "Please try again", preferredStyle: .Alert)
            //let alertview = UIAlertView(title: "invalid username or password", message: "The username and/or password is not valid.. Please try again", delegate: self, cancelButtonTitle: "Ok");
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertcontroller.addAction(defaultAction)
            //alertview.show()
            self.presentViewController(alertcontroller, animated: true, completion: nil)
        }
        
        
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
