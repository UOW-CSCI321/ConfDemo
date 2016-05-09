//
//  Event.swift
//  ConfPlus
//
//  Created by CY Lim on 8/05/2016.
//  Copyright © 2016 Conf+. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class Event: NSManagedObject {
	
	func getImage() -> UIImage{
		if (poster_url != "" || poster_url != nil) {
			if let dataString = poster_url {
				if let data = dataString.componentsSeparatedByString(",").last {
					if let decodedData = NSData(base64EncodedString: data, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters) {
						return UIImage(data: decodedData)!
					}
				}
			}
		}
		return UIImage(named: "matt")!
	}

// Insert code here to add functionality to your managed object subclass
	func setFromDate/*serverStringToDate*/(dateString:String) /*-> NSDate*/
	{
		//move into model class for event eventually
		
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		dateFormatter.timeZone = NSTimeZone(name: "GMT")
		//dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
		
		let d1 = dateFormatter.dateFromString(dateString)
		//print(dateStart)
		//return d1!
		self.from_date = d1
		//print("setFromdate(\(dateString)) -> \(d1)")
	}
	
	func setToDate/*serverStringToDate*/(dateString:String) /*-> NSDate*/
	{
		//move into model class for event eventually
		
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		dateFormatter.timeZone = NSTimeZone(name: "GMT")
		//dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
		
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
}
