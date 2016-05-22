//
//  Message+CoreDataProperties.swift
//  
//
//  Created by Matthew Boroczky on 22/05/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Message {

    @NSManaged var content: String?
    @NSManaged var date: NSDate?
    @NSManaged var sender_email: String?
    @NSManaged var message_id: String?
    @NSManaged var display_name: String?
    @NSManaged var conversation: Conversation?
    @NSManaged var sender: User?

}
