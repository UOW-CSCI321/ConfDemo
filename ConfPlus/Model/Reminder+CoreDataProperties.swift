//
//  Reminder+CoreDataProperties.swift
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

extension Reminder {

    @NSManaged var message: String?
    @NSManaged var time: NSDate?
    @NSManaged var event: NSManagedObject?

}
