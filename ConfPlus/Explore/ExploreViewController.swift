//
//  ExploreViewController.swift
//  confDemo
//
//  Created by CY Lim on 2015/10/08.
//  Copyright © 2015年 CY Lim. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ExploreViewController: UIViewController, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        data_request()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("exploreCell", forIndexPath: indexPath) as! ExploreTableViewCell
        
        cell.eventName.text = "Event Name"
        cell.eventDate.text = "Date"
        
        return cell
    }
    
    func dateToFullStyleString(dateString:String) -> String
    { //move into model class for event eventually
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "GMT")
        //dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
        
        let d1 = dateFormatter.dateFromString(dateString)
        //print(dateStart)
        
        let df = NSDateFormatter()
        df.dateStyle = NSDateFormatterStyle.FullStyle
        let dstring = df.stringFromDate(d1!)
        //print(dstring)
        return dstring
    }
    
    func data_request()
    {
        let paramaters = [
            "method" : "getEvent",
            "event_id" : "1"
        ] //at the moment the api call need event id
        
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
                        let eventName = json["data"][0]["name"].stringValue
                        //let password = json["data"][0]["password"].stringValue //data[0].password
                        let eventStartString = self.dateToFullStyleString(json["data"][0]["from_date"].stringValue)
                        let eventEndString = self.dateToFullStyleString(json["data"][0]["to_date"].stringValue)
                        let desc = json["data"][0]["description"].stringValue
                        let posterUrl = json["data"][0]["poster_url"].stringValue
                        
                    }
                case .Failure(let error):
                    print(error)
                    
                }
                
            }
            
        }else {
            print("server not set in LoginViewController")
        }
        //return password;
        
    }


}
