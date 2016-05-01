//
//  Event+CoreDataProperties.swift
//  
//
//  Created by Matthew Boroczky on 1/05/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Event {

    @NSManaged var desc: String?
    @NSManaged var event_id: NSNumber?
    @NSManaged var from_date: NSDate?
    @NSManaged var name: String?
    @NSManaged var poster: NSData?
    @NSManaged var poster_url: String?
    @NSManaged var to_date: NSDate?
    @NSManaged var type: String?
    @NSManaged var url: String?
    @NSManaged var reminder: String?
    @NSManaged var sessions: NSSet?
    @NSManaged var tags: NSSet?
    @NSManaged var roles: NSSet?

}
