//
//  Session+CoreDataProperties.swift
//  
//
//  Created by Matthew Boroczky on 4/06/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Session {

    @NSManaged var end_time: NSDate?
    @NSManaged var event_id: String?
    @NSManaged var room_name: String?
    @NSManaged var session_description: String?
    @NSManaged var speaker_email: String?
    @NSManaged var start_time: NSDate?
    @NSManaged var title: String?
    @NSManaged var event: Event?
    @NSManaged var tickets: NSSet?
    @NSManaged var user: User?

}
