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
			print("Failure to update CoreData")
		}
	}
	
	func getExploreData() -> [Event]{
        let request = NSFetchRequest(entityName: "Event")
        //let entityDescription = NSEntityDescription.entityForName("Event", inManagedObjectContext: context)
        //request.entity = entityDescription
        
        let predicate = NSPredicate(format: "user_is_attending == %@", 0) //where attending == false
        request.predicate = predicate
        
        
        var events = [Event]()
        do {
            events = try context.executeFetchRequest(request) as! [Event]
        } catch {
            print("Could not retrieve events object")
        }
        return events

	}
	
    //Events
    //Explore tab
    func addNewEvent(json: JSON, attending:NSNumber) -> Event{
		
		
		let entityDescription = NSEntityDescription.entityForName("Event", inManagedObjectContext: context)
		
		let event = Event(entity: entityDescription!, insertIntoManagedObjectContext: self.context)
		event.event_id = json["event_id"].string
		event.name = json["name"].string
		event.type = json["type"].string
		event.setFromDate(json["from_date"].stringValue)
		event.setToDate(json["to_date"].stringValue)
		event.desc = json["description"].string
		event.url = json["url"].string
		event.venue_id = json["venue_id"].string
        event.user_is_attending = attending
		
		//performUpdate()
		
		return event
	}
	
	func deleteEventsData(){
		let events = getExploreData()
		for event in events{
			self.context.deleteObject(event)
		}
		
		performUpdate()
	}
	
	func getVenueByEvent(event: Event) -> Venue?{
		let request = NSFetchRequest()
		let entityDescription = NSEntityDescription.entityForName("Venue", inManagedObjectContext: context)
		request.entity = entityDescription
		request.fetchLimit = 1
		
		guard let venue_id = event.venue_id else {
			print("error 1")
			return nil
		}
		let predicate = NSPredicate(format: "venue_id == %@", venue_id)
		request.predicate = predicate
		
		do{
			let results = try context.executeFetchRequest(request)
			print(results)
			guard let venue = results.first else {
				print("error 2")
				return nil
			}
			return venue as? Venue
		} catch {
			print("Failed to search for venue from \(event.name)")
		}
		return nil
	}
	
	func addNewVenue(json: JSON) -> Venue{
		let venue = NSEntityDescription.insertNewObjectForEntityForName("Venue", inManagedObjectContext: self.context) as! Venue
		venue.venue_id = json["venue_id"].string
		venue.name = json["name"].string
		venue.type = json["type"].string
		venue.street = json["street"].string
		venue.city = json["city"].string
		venue.state = json["state"].string
		venue.country = json["country"].string
		venue.latitude = json["latitude"].string
		venue.longitude = json["longitude"].string
		
		performUpdate()
		
		return venue
	}
	
	func saveVenueForEvent(event:Event, venue:Venue){
		venue.mutableSetValueForKey("events").addObject(event)
		event.venue = venue
		
		performUpdate()
	}
    
    //events tab
    func getAttendedEventsByEmail(email:String) -> [Event]
    {
//        //call getUser(email)
//        let foundUser = getUser(email)
//        //get the nsset of event_roles for the user NSSet roles = foundUser.event_roles
//        let userRoles = foundUser?.event_roles
//        //each element in the set has one event so traverse through the nsset and get each event - aevent = roles[i].event
//        for role in userRoles!
//        {
//            aEvent = role.event
//            //append the found event to an array of events
//        }
//        //return the array
        let request = NSFetchRequest(entityName: "Event")
        let entityDescription = NSEntityDescription.entityForName("Event", inManagedObjectContext: context)
        request.entity = entityDescription
        
        let predicate = NSPredicate(format: "user_is_attending == %@", 1) //where attending == true
        request.predicate = predicate


        var events = [Event]()
        do {
            events = try context.executeFetchRequest(request) as! [Event]
        } catch {
            print("Could not retrieve events object")
        }
        return events
        
    }

    func getUser(email:String) -> User?
    {
        let request = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("Venue", inManagedObjectContext: context)
        request.entity = entityDescription
        request.fetchLimit = 1
        
        let predicate = NSPredicate(format: "email == %@", email)
        request.predicate = predicate
        
        do{
            let results = try context.executeFetchRequest(request)
            print(results)
            guard let user = results.first else {
                print("error")
                return nil
            }
            return user as? User
        } catch {
            print("Failed to search for user with email \(email)")
        }
        return nil
    }
}