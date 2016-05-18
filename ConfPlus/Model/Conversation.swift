//
//  Conversation.swift
//  
//
//  Created by Matthew Boroczky on 16/05/2016.
//
//

import Foundation
import CoreData


class Conversation: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    func getConversationDateAsString(/*currentDate:NSDate*/) -> String
    {
        
        let df = NSDateFormatter()
        df.dateStyle = NSDateFormatterStyle.ShortStyle
        df.timeZone = NSTimeZone(name: "GMT")
        var dstring = df.stringFromDate(self.lastmsg_date!)
        
        let today = NSDate();
        let todayString = df.stringFromDate(today);
        //print("today: \(todayString), otherdate: \(dstring)")
        
        //if the date is today show the time instead of the date
        if todayString == dstring
        {
            df.dateStyle = NSDateFormatterStyle.NoStyle
            df.timeStyle = NSDateFormatterStyle.ShortStyle
            dstring = df.stringFromDate(self.lastmsg_date!)
        }
        
        return dstring
    }
}
