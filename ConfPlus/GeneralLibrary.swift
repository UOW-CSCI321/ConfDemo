//
//  GeneralLibrary.swift
//  ConfPlus
//
//  Created by CY Lim on 2/06/2016.
//  Copyright © 2016 Conf+. All rights reserved.
//

import Foundation
import MPGNotification

class GeneralLibrary{
	func unwrapPrice(price:String) -> String{
		return price.componentsSeparatedByString(" ").last!
	}
	
	func getTimeFromDate(date:NSDate) -> String {
		let dateFormatter = NSDateFormatter()
		dateFormatter.timeZone = NSTimeZone(name: "GMT")
		dateFormatter.dateFormat = "HH:mm"
		
		return dateFormatter.stringFromDate(date)
	}
	
	func getStringFromDate(date:NSDate) -> String{
		let dateFormatter = NSDateFormatter()
		dateFormatter.timeZone = NSTimeZone(name: "GMT")
		dateFormatter.dateFormat = "YYYY-MM-dd"
		
		return dateFormatter.stringFromDate(date)
	}
    
    func getDateAsAusStyleString(date:NSDate) -> String
    {
        let aus = NSDateFormatter()
        aus.timeZone = NSTimeZone(name: "GMT")
        aus.dateFormat = "EEEE - dd/M/yy"
        let dstring = aus.stringFromDate(date)
        
        return dstring
    }
    
	func getDateFromString(date:String) -> NSDate{
		let dateFormatter = NSDateFormatter()
		dateFormatter.timeZone = NSTimeZone(name: "GMT")
		dateFormatter.dateFormat = "YYYY-MM-dd"
		
		return dateFormatter.dateFromString(date)!
	}
	
	func getFullStringFromDate(date:NSDate) -> String{
		let dateFormatter = NSDateFormatter()
		dateFormatter.timeZone = NSTimeZone(name: "GMT")
		dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
		
		return dateFormatter.stringFromDate(date)
	}
	
	
	func getMinutes(date:NSDate) -> String {
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "mm"
		dateFormatter.timeZone = NSTimeZone(name: "GMT")
		
		return dateFormatter.stringFromDate(date)
	}
	
	func getFullDate(date:String) -> NSDate{
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		dateFormatter.timeZone = NSTimeZone(name: "GMT")
		
		return dateFormatter.dateFromString(date)!
	}
	
	func fetchError(title: String = "No internet Connection", message:String = "Data might not updated."){
		let notification = MPGNotification(title: title, subtitle: message, backgroundColor: UIColor.orangeColor(), iconImage: nil)
		notification.show()
	}
}