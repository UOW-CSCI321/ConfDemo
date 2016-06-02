//
//  Ticket_Record+CoreDataProperties.swift
//  
//
//  Created by Matthew Boroczky on 2/06/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Ticket_Record {

    @NSManaged var event_id: String?
    @NSManaged var record_id: String?
    @NSManaged var room_name: String?
    @NSManaged var seat_num: String?
    @NSManaged var ticket_class: String?
    @NSManaged var ticket_name: String?
    @NSManaged var title: String?
    @NSManaged var type: String?
    @NSManaged var venue_id: String?
    @NSManaged var ticket_def: Ticket?
    @NSManaged var user: User?

}
