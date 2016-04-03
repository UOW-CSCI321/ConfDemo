//
//  User+CoreDataProperties.swift
//  
//
//  Created by Matthew Boroczky on 3/04/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var active: NSNumber?
    @NSManaged var city: String?
    @NSManaged var country: String?
    @NSManaged var dob: NSDate?
    @NSManaged var email: String?
    @NSManaged var email_verified: NSNumber?
    @NSManaged var fb_id: NSNumber?
    @NSManaged var first_name: String?
    @NSManaged var last_name: String?
    @NSManaged var linkedin_id: NSNumber?
    @NSManaged var password: String?
    @NSManaged var state: String?
    @NSManaged var street: String?
    @NSManaged var title: String?
    @NSManaged var upgraded: NSNumber?
    @NSManaged var username: String?
    @NSManaged var billings: NSSet?
    @NSManaged var events_attended: NSSet?
    @NSManaged var messages_sent: NSSet?
    @NSManaged var payments: NSSet?
    @NSManaged var presenting_sessions: NSSet?
    @NSManaged var sessions_attending: NSSet?
    @NSManaged var user_tags: NSSet?

}
