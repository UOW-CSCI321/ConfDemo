//
//  Ticket+CoreDataProperties.swift
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

extension Ticket {

    @NSManaged var desc: String?
    @NSManaged var end_date: NSDate?
    @NSManaged var name: String?
    @NSManaged var num_purchased: NSNumber?
    @NSManaged var price: NSNumber?
    @NSManaged var quantity: NSNumber?
    @NSManaged var start_date: NSDate?
    @NSManaged var ticket_class: String?
    @NSManaged var type: String?
    @NSManaged var session: Session?
    @NSManaged var ticket_records: NSSet?

}
