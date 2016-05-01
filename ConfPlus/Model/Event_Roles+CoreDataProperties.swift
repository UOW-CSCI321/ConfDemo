//
//  Event_Roles+CoreDataProperties.swift
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

extension Event_Roles {

    @NSManaged var role_name: String?
    @NSManaged var user: User?
    @NSManaged var event: Event?

}
