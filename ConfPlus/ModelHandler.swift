//
//  ModelHandler.swift
//  ConfPlus
//
//  Created by CY Lim on 7/05/2016.
//  Copyright © 2016 Conf+. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import SwiftyJSON

class ModelHandler{
	let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
	
	func performUpdate(){
		do {
			try context.save()
		} catch {
			fatalError("Failure to delete events in ExploreViewController")
		}
	}
	
	func getExploreData() -> [Event]{
		let fetch = NSFetchRequest(entityName: "Event")
		var events = [Event]()
		do {
			events = try context.executeFetchRequest(fetch) as! [Event]
		} catch {
			print("Could not retrieve events object")
		}
		return events
	}
	
	func addNewEvent(json: JSON) -> Event{
		
		let entityDescription = NSEntityDescription.entityForName("Event", inManagedObjectContext: context)
		
		let event = Event(entity: entityDescription!, insertIntoManagedObjectContext: self.context)
		event.event_id = json["event_id"].intValue
		event.name = json["name"].string
		event.type = json["type"].string
		event.setFromDate(json["from_date"].stringValue)
		event.setToDate(json["to_date"].stringValue)
		event.desc = json["description"].string
		event.url = json["url"].string
		
		performUpdate()
		
		return event
	}
	
	func deleteEventsData(){
		let events = getExploreData()
		for event in events{
			self.context.deleteObject(event)
		}
		
		performUpdate()
	}
}