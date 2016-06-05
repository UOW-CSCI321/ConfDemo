//
//  Event+CoreDataProperties.swift
//  ConfPlus
//
//  Created by CY Lim on 4/06/2016.
//  Copyright © 2016 Conf+. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Event {

    @NSManaged var attend: String?
    @NSManaged var desc: String?
    @NSManaged var event_id: String?
    @NSManaged var from_date: NSDate?
    @NSManaged var name: String?
    @NSManaged var poster: NSData?
    @NSManaged var poster_url: String?
    @NSManaged var reminder: String?
    @NSManaged var security_num: String?
    @NSManaged var to_date: NSDate?
    @NSManaged var type: String?
    @NSManaged var url: String?
    @NSManaged var venue_id: String?
    @NSManaged var payee: String?
    @NSManaged var cardNum: String?
    @NSManaged var roles: NSSet?
    @NSManaged var sessions: NSSet?
    @NSManaged var tags: NSSet?
    @NSManaged var venue: Venue?

}
