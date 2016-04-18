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
    
    /*func parseJSON()
    {
        let path : String = NSBundle.mainBundle().pathForResource("jsonfile", ofType: "json") as String!
        let jsonData = NSData(/*contentsOfURL: <#T##NSURL#>*/ contentsOfFile: path) as NSData
        let readableJSON = JSON
    }*/
    
    /*func loadJSONData()
    {
        Alamofire.request(.POST, "b0d1d301.ngrok.io/api/v1?action=getUser")
            .responseJSON { (request, response, JSON_, error) in
                if let final = JSON_ {
                    if let final_2 = JSON(final).dictionaryObject
                }
    }*/
    
    func data_request(email : String)/* -> String*/
    {
        /*let url:NSURL = NSURL(string: "b0d1d301.ngrok.io/api/v1")!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let paramString = "method=getUser&email=matt1@test.com"
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            
            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print(dataString)
            
        }
        
        task.resume()*/
        
        let paramaters = [
            "method" : "getUser",
            "email" : email
        ]
        
        var jsonArray : NSMutableArray?
        //var password: String
        
        Alamofire.request(.POST, "https://b0d1d301.ngrok.io/api/v1", parameters: paramaters).responseJSON {
            //response in debugPrint(response)
            (response) -> Void in
            if let JSON = response.result.value
            {
                jsonArray = JSON as? NSMutableArray
                /*for item in jsonArray!{
                 print(item["data"])
                 }*/
                //print(JSON["data"])
                let data = JSON["data"]
                print(data)
                //let password = data!![0].password
                //print(password)
                
                
            }
        }

        
    }
    
    @IBAction func LoginPressed(sender: AnyObject) {
        let username = usernameTextfield.text
        let password = passwordTextfield.text
        //let real_pwd = data_request(username!)
        
        data_request(username!)
        /*print("LOGIN pressed")
        let username = usernameTextfield.text
        let password = passwordTextfield.text
        
        let url = NSURL(string: "http://b0d1d301.ngrok.io/api/v1")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        let postString = "method=getUser&email=\(username)"
        print(postString)
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error: \(error)")
                return
            }
            
            //print response obj
            print("*** response = \(response)")
            
            //print response body
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("*** response data \(responseString)")
            
            //var err:NSError?
            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
            
            if let parseJSON = json {
                var username = parseJSON["username"] as? String
                print("username: \(username)")
            }
            
            
        }
        task.resume()*/
        
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
