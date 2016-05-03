//
//  Ticket_Record+CoreDataProperties.swift
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

extension Ticket_Record {

    @NSManaged var record_id: NSNumber?
    @NSManaged var event_id: NSNumber?
    @NSManaged var title: String?
    @NSManaged var ticket_name: String?
    @NSManaged var ticket_class: String?
    @NSManaged var type: String?
    @NSManaged var venue_id: NSNumber?
    @NSManaged var room_name: String?
    @NSManaged var seat_num: NSNumber?
    @NSManaged var user: User?
    @NSManaged var ticket_def: Ticket?

}
