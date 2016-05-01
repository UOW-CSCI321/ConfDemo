//
//  Participants+CoreDataProperties.swift
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

extension Participants {

    @NSManaged var conversation_id: NSNumber?
    @NSManaged var conversation: Conversation?
    @NSManaged var user: User?

}
