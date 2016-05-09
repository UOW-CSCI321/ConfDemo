//
//  Ticket_Record+CoreDataProperties.swift
//  ConfPlus
//
//  Created by CY Lim on 8/05/2016.
//  Copyright © 2016 Conf+. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Ticket_Record {

    @NSManaged var event_id: NSNumber?
    @NSManaged var record_id: NSNumber?
    @NSManaged var room_name: String?
    @NSManaged var seat_num: NSNumber?
    @NSManaged var ticket_class: String?
    @NSManaged var ticket_name: String?
    @NSManaged var title: String?
    @NSManaged var type: String?
    @NSManaged var venue_id: NSNumber?
    @NSManaged var ticket_def: Ticket?
    @NSManaged var user: User?

}
