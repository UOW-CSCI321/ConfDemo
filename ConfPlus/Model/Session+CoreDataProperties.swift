//
//  Session+CoreDataProperties.swift
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

extension Session {

    @NSManaged var end_time: NSDate?
    @NSManaged var room_name: String?
    @NSManaged var speaker_email: String?
    @NSManaged var start_time: NSDate?
    @NSManaged var title: String?
    @NSManaged var event: Event?
    @NSManaged var speaker: User?
    @NSManaged var tickets: NSSet?

}
