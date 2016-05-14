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
	
	func getEvents(attend: String) -> [Event]{
		let fetch = NSFetchRequest(entityName: "Event")
        let predicate = NSPredicate(format: "attend == %@", attend)
        fetch.predicate = predicate
        
		var events = [Event]()
		do {
			events = try context.executeFetchRequest(fetch) as! [Event]
            //print(events[0])
		} catch {
			print("Could not retrieve events object")
		}
		return events
	}
	
    //Events
    //Explore tab
	func addNewEvent(json: JSON, attending:String) -> Event{
		
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
        event.attend = attending
		
		//performUpdate()
		
		return event
	}
	
	func deleteEventsData(){
		let events = getEvents("0")
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
    
    func serverStringToDate(dateString:String) -> NSDate
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "GMT")
        
        let d1 = dateFormatter.dateFromString(dateString)
        return d1!
    }

    func addNewUser(json: JSON) -> User
    {
        let user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: self.context) as! User
        user.email = json["email"].string
        user.username = json["username"].string
        user.password = json["password"].string //eventually do some hashing
        user.title = json["title"].string
        user.first_name = json["first_name"].string
        user.last_name = json["last_name"].string
        user.dob = serverStringToDate(json["dob"].string!)
        user.street = json["street"].string
        user.city = json["city"].string
        user.state = json["state"].string
        user.country = json["country"].string
        user.fb_id = json["fb_id"].number
        user.linkedin_id = json["linkedin_id"].number
        user.active = json["active"].number
        user.upgraded = json["upgraded"].number
        
        performUpdate()
        
        return user
    }

    func getUser(email:String) -> User?
    {
        let request = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("User", inManagedObjectContext: context)
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
    
    func addNewConversation(json: JSON) -> Conversation
    {
        let convo = NSEntityDescription.insertNewObjectForEntityForName("Conversation", inManagedObjectContext: self.context) as! Conversation
        convo.conversation_id = json["conversation_id"].string
        convo.name = json["name"].string
        print(convo.conversation_id)
        print(convo.name)
        
        performUpdate()
        
        return convo
    }
    
    func addNewMessage(json: JSON) -> Message
    {
        let message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: self.context) as! Message

        message.content = json["content"].string
        message.date = serverStringToDate(json["updated_at"].string!)
        message.sender_email = json["sender_email"].string
        
        performUpdate()
        
        return message
    }

    
    func getMessageForConversation(conversation:Conversation) -> [Message]?
    {
        let request = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("Message", inManagedObjectContext: context)
        request.entity = entityDescription
        //request.fetchLimit = 1
        
//        guard let venue_id = event.venue_id else {
//            print("error 1")
//            return nil
//        }
        //let predicate = NSPredicate(format: "venue_id == %@", venue_id) //get the venu_id from venue where it is = the var venu_id
        let predicate = NSPredicate(format: "conversation == %@", conversation)
        request.predicate = predicate
        
        var messages = [Message]()
        do{
            //let results = try context.executeFetchRequest(request)
            messages = try context.executeFetchRequest(request) as! [Message]
            //print(results)
//            guard let venue = results.first else {
//                print("error")
//                return nil
//            }
            return messages
        } catch {
            print("Failed to search for messages from conversation:\(conversation.conversation_id)")
        }
        return nil

    }
    
    func getConversation() -> [Conversation]
    {
        let fetch = NSFetchRequest(entityName: "Conversation")
        //let predicate = NSPredicate(format: "attend == %@", attend)
        //fetch.predicate = predicate

        var conversations = [Conversation]()
        do {
            conversations = try context.executeFetchRequest(fetch) as! [Conversation]
            //print(events[0])
        } catch {
            print("Could not retrieve conversation objects")
        }
        return conversations

    }
}


//MARK: - Account Related
extension ModelHandler {
	func addNewPaymentHistory(json:JSON){
		let entityDescription = NSEntityDescription.entityForName("Payment", inManagedObjectContext: context)
		
		let history = Payment(entity: entityDescription!, insertIntoManagedObjectContext: self.context)
		history.payment_id = json["payment_id"].int
		history.payment_date = serverStringToDate(json["payment_date"].string!)
		history.amount = json["amount"].float
		history.type = json["type"].string
		
		performUpdate()
	}
	
	func getPaymentHistory() -> [Payment]{
		let fetch = NSFetchRequest()
		let entityDescription = NSEntityDescription.entityForName("Payment", inManagedObjectContext: context)
		fetch.entity = entityDescription
		
		var history = [Payment]()
		do {
			history = try context.executeFetchRequest(fetch) as! [Payment]
			//print(events[0])
		} catch {
			print("Could not retrieve payment object")
		}
		return history
	}
}