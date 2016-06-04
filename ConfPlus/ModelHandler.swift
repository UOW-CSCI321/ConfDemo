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
	
    //MARK: - Event Related
	func getEvents(attend: String, future: Bool = true) -> [Event]{
		let fetch = NSFetchRequest(entityName: "Event")
        let attendPredicate = NSPredicate(format: "attend == %@", attend)
		var datePredicate = NSPredicate()
		if future {
			datePredicate = NSPredicate(format: "to_date > %@", NSDate())
		} else {
			datePredicate = NSPredicate(format: "to_date < %@", NSDate())
		}
		let predicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: [attendPredicate, datePredicate])
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
	func addNewEvent(json: JSON, attending:String){
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
        event.security_num = json["contact_num"].string
        event.attend = attending
		
		performUpdate()
	}
	
	func updatePosterForEvent(event:Event, data:String) -> Event {
		event.poster_url = data
		
		performUpdate()
		
		return event
	}
	
	func deleteEventsData(){
		let events = getEvents("0")
		for event in events{
			self.context.deleteObject(event)
		}
		
		performUpdate()
	}
    
    //MARK: Session Related
    func addNewSession(json:JSON) -> Session? {
        
        let entityDescription = NSEntityDescription.entityForName("Session", inManagedObjectContext: context)
        
        let session = Session(entity: entityDescription!, insertIntoManagedObjectContext: self.context)
        session.title = json["title"].string
        session.speaker_email = json["speaker_email"].string
        session.session_description = json["description"].string
        
        session.start_time = serverStringToDate(json["start_time"].string!)
        session.end_time = serverStringToDate(json["end_time"].string!)
        session.event_id = json["event_id"].string
                
//        print(json)
//        print(json["title"].string)
//        print(json["speaker_email"].string)
//        print(json["description"].string)
//        
//        print(json["start_time"].string!)
//        print(json["end_time"].string!)
        
        performUpdate()
        
        //if the title (the id) is nil then we have already saved it into the database before
        if session.title == nil
        {
            return nil
        }

        return session
    }
    
    func saveSessionForUser(session:Session, user:User) {
        user.mutableSetValueForKey("attending_sessions").addObject(session)
        session.user = user
//        venue.mutableSetValueForKey("events").addObject(event)
//        event.venue = venue
        //1 venue multiple events
        //1 user multiple sessions
        
        performUpdate()
    }
    
    func saveSessionForEvent(session:Session, event:Event) {
        //1 event many session
        event.mutableSetValueForKey("sessions").addObject(session)
        session.event = event
        
        performUpdate()
        
        //print("saved session: \(session.title) \(session.event_id) for event: \(event.event_id) \(event.name)")
        
    }
    
    //get sessions only for event
    func getSessionsForEvent(event:Event) -> [Session]
    {
        //print("CONVERSATION ID:\(conversation.conversation_id)")
        let fetch = NSFetchRequest(entityName: "Session")
        fetch.predicate = NSPredicate(format: "event == %@", event)
        fetch.sortDescriptors = [NSSortDescriptor(key: "start_time", ascending: true)]
        
        var sessions = [Session]()
        do {
            sessions = try context.executeFetchRequest(fetch) as! [Session]
            
            //print(messages.count)
        } catch {
            print("Could not retrieve events object")
        }
        return sessions

    }
    
    //get sessions only for an event that a user is attending
    //TODO:
	
    //MARK: - Venue Related
	func getVenueByEvent(event: Event) -> Venue?{
		let request = NSFetchRequest()
		let entityDescription = NSEntityDescription.entityForName("Venue", inManagedObjectContext: context)
		request.entity = entityDescription
		request.fetchLimit = 1
		
		guard let venue_id = event.venue_id else {
			return nil
		}
		let predicate = NSPredicate(format: "venue_id == %@", venue_id)
		request.predicate = predicate
		
		do{
			let results = try context.executeFetchRequest(request)
			print(results)
			guard let venue = results.first else {
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
		
		//performUpdate()
		
		return venue
	}
	
	func saveVenueForEvent(event:Event, venue:Venue){
		venue.mutableSetValueForKey("events").addObject(event)
		event.venue = venue
		
		performUpdate()
	}
    
    func updateMapForVenue(venue:Venue, data:String) -> Venue {
        venue.map = data
        performUpdate()
        
        return venue
    }
    
    func serverStringToDate(dateString:String) -> NSDate
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "GMT")
        
        let d1 = dateFormatter.dateFromString(dateString)
        return d1!
    }

    //MARK: - User related
    func addNewUser(json: JSON) -> User?
    {
        //print(json)
        let user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: self.context) as! User
        user.email = json["email"].string
        user.username = json["username"].string
        user.password = json["password"].string //eventually do some hashing
        user.title = json["title"].string
        user.first_name = json["first_name"].string
        user.last_name = json["last_name"].string
        if json["dob"].string != nil {
            user.dob = serverStringToDate(json["dob"].string!)
        }
        user.street = json["street"].string
        user.city = json["city"].string
        user.state = json["state"].string
        user.country = json["country"].string
        user.fb_id = json["fb_id"].number
        user.linkedin_id = json["linkedin_id"].number
        user.active = json["active"].number
        user.upgraded = json["upgraded"].number
        user.profile_pic_url = json["image_data_url"].string
        
//        print(user.email)
//        print(user.username)
//        print(user.password)
//        print(user.title)
//        print(user.first_name)
//        print(user.last_name)
//      
//        print(user.street)
//        print(user.city)
//        print(user.state)
//        print(user.country)
//        print(user.fb_id)
//        print(user.linkedin_id)
//        print(user.active)
//        print(user.upgraded)
        
        performUpdate()
        
//        print(user.email)
//        print(user.username)
//        print(user.password)
//        print(user.title)
//        print(user.first_name)
//        print(user.last_name)
//        
//        print(user.street)
//        print(user.city)
//        print(user.state)
//        print(user.country)
//        print(user.fb_id)
//        print(user.linkedin_id)
//        print(user.active)
//        print(user.upgraded)
        
        if user.email == nil
        {
            return nil
        }

        
        return user
    }

    func getUser(email:String) -> User?
    {
        let request = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("User", inManagedObjectContext: context)
        request.entity = entityDescription
        request.fetchLimit = 1
        
        let predicate = NSPredicate(format: "email = %@", email)
        request.predicate = predicate
        
        do{
            let results = try context.executeFetchRequest(request)
            //print(results)
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
    
    
    func updateUsersProfilePic(user:User, data:String) -> User {
        //event.poster_url = data
        user.profile_pic_url = data
        //print(user.profile_pic_url)
        performUpdate()
        
        return user
    }
    
    //MARK: - Conversation/Message related
    
    func getUsersForConversation(conversation:Conversation) -> [User]?
    {
        let request = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: context)
        
        let predicate = NSPredicate(format: "ANY conversations == %@", conversation)
        //let predicate = NSPredicate(format: "users IN %@.users", conversation)
        
        request.entity = entity
        request.predicate = predicate
        
        var users = [User]()
        do{
            users = try context.executeFetchRequest(request) as! [User]
            //print(users)
            return users
        } catch {
            print("Failed to search for usesr in conversation \(conversation.conversation_id)")
        }
        return nil
    }
    
    func saveUserForConversation(user:User, conversation:Conversation)
    {
        print("saving \(user.first_name) \(user.last_name) \(user.email) for conversation \(conversation.conversation_id)")
        conversation.mutableSetValueForKey("users").addObject(user)
        user.mutableSetValueForKey("conversations").addObject(conversation)
        performUpdate()
    }
    
    func addNewConversation(json: JSON) -> Conversation
    {
        let convo = NSEntityDescription.insertNewObjectForEntityForName("Conversation", inManagedObjectContext: self.context) as! Conversation
        convo.conversation_id = json["conversation_id"].string
        convo.name = json["name"].string
        convo.lastmsg_content = json["content"].string
        convo.lastmsg_email = json["sender_email"].string
        convo.lastmsg_date = serverStringToDate(json["date"].string!)
//        print(convo.conversation_id)
//        print(convo.name)
//        print(convo.lastmsg_content)
//        print(convo.lastmsg_email)
//        print(convo.lastmsg_date)
        
        performUpdate()
        
        return convo
    }
    
    func addNewMessage(json: JSON, conversation:Conversation) -> Message
    {
		
		let entityDescription = NSEntityDescription.entityForName("Message", inManagedObjectContext: context)
		
		let message = Message(entity: entityDescription!, insertIntoManagedObjectContext: self.context)
		//print(json)
        message.id = json["message_id"].string
        message.content = json["content"].string
        message.date = serverStringToDate(json["date"].string!)
        message.sender_email = json["sender_email"].string
        conversation.mutableSetValueForKey("messages").addObject(message)
        message.conversation = conversation
        //print(message.message_id)
//        print(message.content)
//        print(message.date)
//        print(message.sender_email)
		
		performUpdate()
        
		return message
    }

//    func saveMessageForConversation(conversation:Conversation, message:Message){
//        conversation.mutableSetValueForKey("messages").addObject(message)
//        message.conversation = conversation
//        
//        performUpdate()
//    }
    
    func getMessageForConversation(conversation:Conversation) -> [Message]?
    {
		//print("CONVERSATION ID:\(conversation.conversation_id)")
		let fetch = NSFetchRequest(entityName: "Message")
        fetch.predicate = NSPredicate(format: "conversation == %@", conversation)
		
		var messages = [Message]()
		do {
			messages = try context.executeFetchRequest(fetch) as! [Message]
            
            //print(messages.count)
		} catch {
			print("Could not retrieve events object")
		}
		return messages

    }
    
    func getConversation(email:String) -> [Conversation]
    {
        let fetch = NSFetchRequest(entityName: "Conversation")
        fetch.sortDescriptors = [NSSortDescriptor(key: "lastmsg_date", ascending: false)]
        //fetch.predicate = NSPredicate(format: "users.email == %@", "matt3@test.com")
//        if let myself = getUser(email)
//        {
////            myself.messages_sent
//            fetch.predicate = NSPredicate(format: "users == %@", myself)
//        }else{
//            return nil
//        }
        //i think predicate is needed here or else if user logs after another user you will see their conversations

        var conversations = [Conversation]()
        do {
            conversations = try context.executeFetchRequest(fetch) as! [Conversation]
            //print(events[0])
        } catch {
            print("Could not retrieve conversation objects")
        }
        return conversations

    }
    
    //MARK: - Ticket Related
    func addNewTicket(json: JSON) -> Ticket_Record? {
        let entityDescription = NSEntityDescription.entityForName("Ticket_Record", inManagedObjectContext: context)
        
        let ticket = Ticket_Record(entity: entityDescription!, insertIntoManagedObjectContext: self.context)
        ticket.record_id = json["record_id"].string
        ticket.event_id = json["event_id"].string
        ticket.title = json["title"].string
        ticket.ticket_name = json["ticket_name"].string
        ticket.ticket_class = json["class"].string
        ticket.type = json["type"].string
        ticket.venue_id = json["venue_id"].string
        ticket.room_name = json["room_name"].string
        ticket.seat_num = json["seat_num"].string
        
        performUpdate()
        
//        print("adding new ticket:")
//        print(ticket.record_id)
//        print(ticket.event_id)
//        print(ticket.title)
//        print(ticket.ticket_name)
//        print(ticket.ticket_class)
//        print(ticket.type)
//        print(ticket.venue_id)
//        print(ticket.room_name)
//        print(ticket.seat_num)
        
        if ticket.record_id == nil
        {
            return nil
        }

        return ticket
    }
    
    func saveTicketForUser(ticket:Ticket_Record, user:User){
        user.mutableSetValueForKey("ticket_records").addObject(ticket)
        ticket.user = user
		
		performUpdate()
	}
    
    func getTicketsForUser(user:User) -> [Ticket_Record]? {
       
        let fetch = NSFetchRequest(entityName: "Ticket_Record")
        fetch.predicate = NSPredicate(format: "user == %@", user)

        var tickets = [Ticket_Record]()
        do {
            tickets = try context.executeFetchRequest(fetch) as! [Ticket_Record]
            
            //print(messages.count)
        } catch {
            print("Could not retrieve events object")
        }
        return tickets

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
		} catch {
			print("Could not retrieve payment object")
		}
		return history
	}
}