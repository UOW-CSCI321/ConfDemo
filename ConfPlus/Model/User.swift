//
//  User.swift
//  
//
//  Created by Matthew Boroczky on 4/04/2016.
//
//

import Foundation
import CoreData
import UIKit


class User: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    /*static func addUser(userObj: User) -> Bool
    {
        let appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context : NSManagedObjectContext = appDel.managedObjectContext
        let aUser = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: context) as NSManagedObject
        
        aUser.setValue(userObj.username, forKey: "username")
        aUser.setValue(userObj.upgraded, forKey: "upgraded")
        aUser.setValue(userObj.title, forKey: "title")
        aUser.setValue(userObj.street, forKey: "street")
        aUser.setValue(userObj.state, forKey: "state")
        aUser.setValue(userObj.password, forKey: "password")
        aUser.setValue(userObj.linkedin_id, forKey: "linkedin_id")
        aUser.setValue(userObj.last_name, forKey: "last_name")
        aUser.setValue(userObj.first_name, forKey: "first_name")
        aUser.setValue(userObj.fb_id, forKey: "fb_id");
        aUser.setValue(userObj.email_verified, forKey: "email_verified")
        aUser.setValue(userObj.email, forKey: "email")
        aUser.setValue(userObj.dob, forKey: "dob")
        aUser.setValue(userObj.country, forKey: "country")
        aUser.setValue(userObj.city, forKey: "city")
        aUser.setValue(userObj.active, forKey: "active")
        
        print(aUser);
        
        do
        {
            try context.save()
            return true
        }catch
        {
            return false
        }
    }*/
    
    /*init(username: String, upgraded:Bool,title: String,street:String, state:String, password:String, linkedin_id:NSInteger, last_name:String, first_name:String, fb_id:NSInteger, email_verified:Bool, email:String, dob:NSDate, country:String, city:String, active:Bool){
        
        self.username = username
        self.upgraded = upgraded
        self.title = title
        self.street = street
        self.state = state
        self.password = password
        self.linkedin_id = linkedin_id
        self.last_name = last_name
        self.first_name = first_name
        self.fb_id = fb_id
        self.email_verified = email_verified
        self.email = email
        self.dob = dob
        self.country = country
        self.city = city
        self.active = active
    }
    
    func setName(first: String, second:String) -> Bool
    {
        self.last_name = first
        self.first_name = second
    }*/

}
