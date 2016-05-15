//
//  Conversation+CoreDataProperties.swift
//  
//
//  Created by Matthew Boroczky on 15/05/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Conversation {

    @NSManaged var conversation_id: String?
    @NSManaged var name: String?
    @NSManaged var lastmsg_email: String?
    @NSManaged var lastmsg_date: NSDate?
    @NSManaged var lastmsg_content: String?
    @NSManaged var messages: NSSet?
    @NSManaged var users: NSSet?

}
