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
import CoreData
import Foundation


class ExploreViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet var EventsTableView: UITableView!
    var eventArray = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("https://6f7a5a2d.ngrok.io/api/v1", forKey: "server");
        data_request()
		
		navigationController?.hidesBarsOnSwipe = true
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventArray.count
    }
    
//    func imageTypeIsValid(base64string : String) -> String
//    {
//        var s1 = base64string
//        s1.removeRange(s1.startIndex..<s1.startIndex.advancedBy(11))
//        //.startIndex.advancedBy(10)
//        //print("imgtype: \(s1)")
//
//        let delim : Character = ";"
//        let index = s1.lowercaseString.characters.indexOf(delim)
//        //print("index: \(index)")
//        let imgType = s1.substringToIndex(index!)
//        //print("imgtype \(imgType)")
//        
//        if imgType == "png" || imgType == "PNG" || imgType == "jpeg" || imgType == "JPEG" || imgType == "gif" || imgType == "GIF"
//        {
//            //print("valid type")
//            return imgType
//        }
//        return "invalid"
//    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("exploreCell", forIndexPath: indexPath) as! ExploreTableViewCell
        
        //get from database
        //coredata
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        let eventEntity = NSEntityDescription.entityForName("Event", inManagedObjectContext: context)
        // Fetch
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = eventEntity
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try context.executeFetchRequest(fetchRequest) as! [Event]
                cell.eventName.text = result[indexPath.row].name
                cell.eventDate.text = result[indexPath.row].getFromDateAsString()
            //if let auser = NSURL(stringby)
            let urlString = result[indexPath.row].poster_url
            if(urlString == "")
            {
                print("poster url is empty")
            }else
            {
                var picString = result[indexPath.row].poster_url!
                print("HERE: \(result[indexPath.row].poster_url!) HERE2")
               // print(picString)
//picString = "data:image/gif;base64,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"
                
                //result[indexPath.row].poster_url! = picString //TEMPORARY
//                let imgtype = result[indexPath.row].imageTypeIsValid() //imageTypeIsValid(picString)
//                if(imgtype == "invalid"){
//                    print("error image from server is not a valid type")
//                }else{
//                    
//                    let img = "data:image/\(imgtype);base64,"
//                    if let range = picString.rangeOfString(img, options: .AnchoredSearch)  {
//                        picString.removeRange(range)
//                    }
//                    
//                    if let decodedData = NSData(base64EncodedString: picString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters) {
//                        //print("decoded data: \(decodedData)")
//                        
//                        
//                        if let decodedimage = UIImage(data: decodedData, scale: 1.0){
//                            print(decodedimage)
//                            cell.eventImage.image = decodedimage
//                        }
//                    }
//                }
                cell.eventImage.image = result[indexPath.row].getImage()

            }
            

            //print(result)
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return cell
    }
 
//    func serverStringToDate(dateString:String) -> NSDate
//    {
//        //move into model class for event eventually
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        dateFormatter.timeZone = NSTimeZone(name: "GMT")
//        //dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
//        
//        let d1 = dateFormatter.dateFromString(dateString)
//        //print(dateStart)
//        return d1!
//    }
//    
//    func dateToFullStyleString(date:NSDate) -> String
//    {
//        
//        let df = NSDateFormatter()
//        df.dateStyle = NSDateFormatterStyle.FullStyle
//        let dstring = df.stringFromDate(date)
//        //print(dstring)
//        return dstring
//    }
    
    /*func serverStringToDateToString(dateString:String) -> String
    {
        let adateObj = serverStringToDate(dateString)
        let newString = dateToFullStyleString(adateObj)
        return newString
    }*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath:NSIndexPath = self.EventsTableView.indexPathForSelectedRow!
        let eventVC:EventDetailTableViewController = segue.destinationViewController as! EventDetailTableViewController
        //eventVC.descriptionTextView.text =
        eventVC.selectedEvent = eventArray[indexPath.row]
        
    }
    
        
    func data_request()
    {
        //coredata
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        let eventEntity = NSEntityDescription.entityForName("Event", inManagedObjectContext: context)
        
        //post request
        let paramaters = [
            "method" : "getEventsByTag",
            "tag_name" : "testTag"
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

                        for i in 0 ..< json["data"].count
                        {
                            let aevent = NSEntityDescription.insertNewObjectForEntityForName("Event", inManagedObjectContext: context) as! Event
                            aevent.event_id = json["data"][i]["event_id"].intValue
                            //let event_idString = json["data"][i]["event_id"].stringValue
                            aevent.name = json["data"][i]["name"].stringValue
                            aevent.type = json["data"][i]["type"].stringValue
                            //aevent.from_date = self.serverStringToDate(json["data"][i]["from_date"].stringValue)
                            aevent.setFromDate(json["data"][i]["from_date"].stringValue)
                            //aevent.to_date = self.serverStringToDate(json["data"][i]["to_date"].stringValue)
                            aevent.setToDate(json["data"][i]["to_date"].stringValue)
                            //aevent.venueid
                            aevent.desc = json["data"][i]["description"].stringValue
                            //url
                            //aevent.poster_url = json["data"][i]["poster_url"].stringValue
                            aevent.requestPoster()
                            print("id: \(aevent.event_id)")
                            print("name: \(aevent.name)")
                            print("type: \(aevent.type)")
                            print("from date:\(aevent.from_date)")
                            print("to date:\(aevent.to_date)")
                            print("desc: \(aevent.desc)")
                            print("poster: \(aevent.poster_url)")
                            //aevent.tagname
                            
                            
                            self.eventArray.append(aevent);

                        }

                        //save to database
                        do {
                            try context.save()
                        } catch {
                            fatalError("Failure to save context in ExploreViewController: \(error)")
                        }
                        
                        //reload tableview - make sure loading from database not loading from server as we are currently
                        self.EventsTableView.reloadData()
                    }
                case .Failure(let error):
                    print(error)
                    //handle if there is no internet connection by alerting the user
                }
                
            }
        }else {
            print("server not set in ExploreViewController")
        }
    }


}
