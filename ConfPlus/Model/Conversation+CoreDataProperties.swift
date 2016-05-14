//
//  Conversation+CoreDataProperties.swift
//  
//
//  Created by Matthew Boroczky on 14/05/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Conversation {

    @NSManaged var conversation_id: NSNumber?
    @NSManaged var name: String?
    @NSManaged var messages: NSSet?
    @NSManaged var users: NSSet?

}
