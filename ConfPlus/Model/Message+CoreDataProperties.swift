//
//  Message+CoreDataProperties.swift
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

extension Message {

    @NSManaged var content: String?
    @NSManaged var date: NSDate?
    @NSManaged var sender_email: String?
    @NSManaged var conversation: Conversation?
    @NSManaged var sender: User?

}
