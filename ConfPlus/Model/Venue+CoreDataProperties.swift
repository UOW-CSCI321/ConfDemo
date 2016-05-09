//
//  Venue+CoreDataProperties.swift
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

extension Venue {

    @NSManaged var city: String?
    @NSManaged var country: String?
    @NSManaged var latitude: String?
    @NSManaged var longitude: String?
    @NSManaged var name: String?
    @NSManaged var state: String?
    @NSManaged var street: String?
    @NSManaged var type: String?
    @NSManaged var venue_id: String?
    @NSManaged var events: NSSet?

}
