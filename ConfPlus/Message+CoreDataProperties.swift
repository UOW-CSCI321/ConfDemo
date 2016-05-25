//
//  Message+CoreDataProperties.swift
//  ConfPlus
//
//  Created by CY Lim on 22/05/2016.
//  Copyright © 2016 Conf+. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Message {

    @NSManaged var content: String?
    @NSManaged var date: NSDate?
    @NSManaged var display_name: String?
    @NSManaged var sender_email: String?
    @NSManaged var id: String?
    @NSManaged var conversation: Conversation?
    @NSManaged var sender: User?

}
