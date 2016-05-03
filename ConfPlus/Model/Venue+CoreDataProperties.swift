//
//  Venue+CoreDataProperties.swift
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

extension Venue {

    @NSManaged var venue_id: NSNumber?
    @NSManaged var name: String?
    @NSManaged var type: String?
    @NSManaged var street: String?
    @NSManaged var city: String?
    @NSManaged var state: String?
    @NSManaged var country: String?
    @NSManaged var longitude: String?
    @NSManaged var latitude: String?

}
