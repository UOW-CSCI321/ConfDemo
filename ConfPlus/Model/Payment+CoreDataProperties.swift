//
//  Payment+CoreDataProperties.swift
//  
//
//  Created by Matthew Boroczky on 3/04/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Payment {

    @NSManaged var amount: NSNumber?
    @NSManaged var payment_date: NSDate?
    @NSManaged var type: String?
    @NSManaged var user: User?

}
