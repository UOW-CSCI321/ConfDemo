//
//  Session_Attending+CoreDataProperties.swift
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

extension Session_Attending {

    @NSManaged var seat_num: String?
    @NSManaged var session: Session?
    @NSManaged var ticket: Ticket?
    @NSManaged var user: User?

}
