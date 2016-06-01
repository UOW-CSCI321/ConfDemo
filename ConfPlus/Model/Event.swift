//
//  Event.swift
//  
//
//  Created by Matthew Boroczky on 9/05/2016.
//
//

import Foundation
import CoreData
import UIKit
import Alamofire
//import Alamofire_Synchronous
import SwiftyJSON


class Event: NSManagedObject {

	
    func getImage() -> UIImage {
		if (poster_url != "" || poster_url != nil) {
			if let dataString = poster_url {
				if let data = dataString.componentsSeparatedByString(",").last {
					if let decodedData = NSData(base64EncodedString: data, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters) {
						
						self.poster = decodedData
						ModelHandler().performUpdate()
						
						return UIImage(data: decodedData)!
					}
				}
			}
		}
		return UIImage(named: "event_placeholder")!
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
        df.dateStyle = NSDateFormatterStyle.MediumStyle
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
        df.dateStyle = NSDateFormatterStyle.MediumStyle
        df.timeZone = NSTimeZone(name: "GMT")
        let dstring = df.stringFromDate(self.to_date!)
        
        //let dstring = df.stringFromDate(date)
        //print(dstring)
        //print("getToDate() gets: \(self.from_date) -> \(dstring)")
        return dstring
    }
}
