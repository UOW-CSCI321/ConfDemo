//
//  Event_Roles+CoreDataProperties.swift
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

extension Event_Roles {

    @NSManaged var role_name: String?
    @NSManaged var event: Event?
    @NSManaged var user: User?

}
