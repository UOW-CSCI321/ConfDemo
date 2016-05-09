//
//  Event.swift
//  
//
//  Created by Matthew Boroczky on 6/05/2016.
//
//

import Foundation
import CoreData
import UIKit
import Alamofire
import Alamofire_Synchronous
import SwiftyJSON


class Event: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    func imageTypeIsValid() -> String
    {
        var s1:String = self.poster_url!
        /*if s1 == ""
        {
            return "invalid"
        }*/
        s1.removeRange(s1.startIndex..<s1.startIndex.advancedBy(11))
        //.startIndex.advancedBy(10)
        //print("imgtype: \(s1)")
        
        let delim : Character = ";"
        let index = s1.lowercaseString.characters.indexOf(delim)
        //print("index: \(index)")
        let imgType = s1.substringToIndex(index!)
        //print("imgtype \(imgType)")
        
        if imgType == "png" || imgType == "PNG" || imgType == "jpeg" || imgType == "JPEG" || imgType == "gif" || imgType == "GIF"
        {
            //print("valid type")
            return imgType
        }
        return "invalid"
    }
    
    func getImage() -> UIImage
    {
        var picString:String = self.poster_url!
        //print(picString)
        let imgtype = self.imageTypeIsValid() //imageTypeIsValid(picString)
        if(imgtype == "invalid"){
            print("error image from server is not a valid type")
            //return nil
        }else{
            
            let img = "data:image/\(imgtype);base64,"
            if let range = picString.rangeOfString(img, options: .AnchoredSearch)  {
                picString.removeRange(range)
            }
            
            if let decodedData = NSData(base64EncodedString: picString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters) {
                //print("decoded data: \(decodedData)")
                
                
                if let decodedimage = UIImage(data: decodedData, scale: 1.0){
                    //print(decodedimage)
                    //cell.eventImage.image = decodedimage
                    return decodedimage
                }
            }
        }
        let a = UIImage() //dummy
        return a
    }
    
    func setFromDate/*serverStringToDate*/(dateString:String) /*-> NSDate*/
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "GMT")
        
        let d1 = dateFormatter.dateFromString(dateString)
        //print(dateStart)
        //return d1!
        self.from_date = d1
        //print("setFromdate(\(dateString)) -> \(d1)")
    }
    
    func setToDate/*serverStringToDate*/(dateString:String) /*-> NSDate*/
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "GMT")
        
        let d1 = dateFormatter.dateFromString(dateString)
        //print(dateStart)
        //return d1!
        self.to_date = d1
        //print("setTodate(\(dateString)) -> \(d1)")
    }
    
    
    
    func getFromDateAsString/*dateToFullStyleString*/() -> String
    {
        
        let df = NSDateFormatter()
        df.dateStyle = NSDateFormatterStyle.FullStyle
        df.timeZone = NSTimeZone(name: "GMT")
        let dstring = df.stringFromDate(self.from_date!)
        
        //let dstring = df.stringFromDate(date)
        //print(dstring)
        //print("getFromDate() gets: \(self.from_date) -> \(dstring)")
        return dstring
        
    }
    
    func getToDateAsString/*dateToFullStyleString*/() -> String
    {
        
        let df = NSDateFormatter()
        df.dateStyle = NSDateFormatterStyle.FullStyle
        df.timeZone = NSTimeZone(name: "GMT")
        let dstring = df.stringFromDate(self.to_date!)
        
        //let dstring = df.stringFromDate(date)
        //print(dstring)
        //print("getToDate() gets: \(self.from_date) -> \(dstring)")
        return dstring
    }
    
    func requestPoster()
    {
        let id = self.event_id!
        let defaults = NSUserDefaults.standardUserDefaults()
        let api_key:String = defaults.stringForKey("api_key")!
        let app_secret:String = defaults.stringForKey("app_secret")!
        //post request
        let paramaters = [
            "method" : "getPoster",
            "event_id" : id,
            "api_key" : api_key,
            "app_secret" : app_secret
        ] //at the moment the api call need event id
        
        //synchronous alamofire request
        if let serverAdd = defaults.stringForKey("server")
        {
            self.poster_url = ""
            let response = Alamofire.request(.POST, serverAdd, parameters: paramaters).responseJSON()
            if let value = response.result.value
            {
                let json = JSON(value)
                
                if json["data"].count > 1
                {
                    print("error in getPoster. >1 posters returned")
                }else
                {
                    self.poster_url = json["data"]["poster_data_url"].stringValue
                    //print(self.poster_url)
                }
            }
        }else {
            print("server not set in ExploreViewController")
        }
    }
    
}
