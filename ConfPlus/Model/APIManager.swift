//
//  APIManager.swift
//  ConfPlus
//
//  Created by CY Lim on 7/05/2016.
//  Copyright © 2016 Conf+. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import Alamofire
import SwiftyJSON
import MPGNotification
import PKHUD

class APIManager{
	
	let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
	let server = APIServer()
	let handler = ModelHandler()
	
	let user = NSUserDefaults.standardUserDefaults()
	
	func fetchError(title: String = "No internet Connection", message:String = "Data might not updated."){
		let notification = MPGNotification(title: title, subtitle: message, backgroundColor: UIColor.orangeColor(), iconImage: nil)
		notification.show()
	}
	
	func getUpcomingEventsByCountry(country:String, completion: (result: Bool) -> Void){
		let parameters = [
			"api_key": server.KEY,
			"app_secret": server.SECRET,
			"method" : "getUpcomingEventsByCountry",
			"country" : country
		] //at the moment the api call need event id
		
		Alamofire.request(.POST, server.URL, parameters: parameters).responseJSON { response in
			switch response.result {
			case .Success:
				if let value = response.result.value {
					let json = JSON(value)
					if json["success"]{
						for i in 0 ..< json["data"].count {
							self.handler.addNewEvent(json["data"][i], attending: "0")
						}
						completion(result: true)
					} else {
						self.fetchError("Connection Issues")
						completion(result: false)
					}
				}
				
			case .Failure(let error):
				print(error.localizedDescription)
				self.fetchError()
				completion(result: false)
			}
			
		}
	}
	
	func getEventsAttending(email:String, criteria:String, completion: (result: Bool) -> Void){
		let parameters = [
			"api_key": server.KEY,
			"app_secret": server.SECRET,
			"method" : "getEventsAttending",
			"email" : email,
			"criteria": criteria
		] //at the moment the api call need event id

		Alamofire.request(.POST, server.URL, parameters: parameters).responseJSON { response in
			switch response.result {
			case .Success:
				if let value = response.result.value {
					let json = JSON(value)
					if json["success"]{
						for i in 0 ..< json["data"].count {
							self.handler.addNewEvent(json["data"][i], attending: "1")
						}
						completion(result: true)
					} else {
						self.fetchError("Life is short", message:"Go to Explore Tab and join some interesting events.")
						completion(result: false)
					}
				}
				
			case .Failure(let error):
				print(error.localizedDescription)
				self.fetchError()
				completion(result: false)
			}
			
		}
	}

	func getPoster(event:Event, completion: (result: Bool) -> Void){
		guard let id = event.event_id else {
			print("No event id", #function)
			return
		}
		let parameters = [
			"api_key": server.KEY,
			"app_secret": server.SECRET,
			"method" : "getPoster",
			"event_id" : id
		]
		
		Alamofire.request(.POST, self.server.URL, parameters: parameters).responseJSON(){ response in
			switch response.result{
			case .Success:
				if let value = response.result.value {
					let json = JSON(value)
					if json["success"]{
						self.handler.updatePosterForEvent(event, data: json["data"]["poster_data_url"].string!)
						completion(result: true)
					} else {
						completion(result: false)
					}
				}
			case .Failure(let error):
				print(error.localizedDescription)
				completion(result: false)
			}
		}
		
	}
	
	
	

	func getVenue(event:Event, completion: (result: Bool) -> Void) {
		guard let id = event.venue_id else {
			completion(result: false)
			return
		}
		
		let parameters = [
			"api_key"	:	server.KEY,
			"app_secret":	server.SECRET,
			"method"	:	"getVenue",
			"venue_id"	:	id
		]
		var venue:Venue? = nil

		Alamofire.request(.POST, server.URL, parameters: parameters).responseJSON { response in
			switch response.result{
			case .Success:
				if let value = response.result.value{
					
					let json = JSON(value)
					if json["success"] {
						venue = self.handler.addNewVenue(json["data"][0])
						
						self.handler.saveVenueForEvent(event, venue:venue!)
						completion(result: true)
					} else {
						print(json["data"][0]["message"])
						completion(result: false)
					}
				}
				
			case .Failure(let error):
				print(error.localizedDescription)
				completion(result: false)
				
			}
			
		}
		
	}
    
    func getMapForVenue(venue:Venue, completion: (result: Bool) -> Void) {
        guard let id = venue.venue_id else {
            completion(result: false)
            return
        }
        
        let parameters = [
            "api_key"	:	server.KEY,
            "app_secret":	server.SECRET,
            "method"	:	"getVenueMap",
            "venue_id"	:	id
        ]
        var v:Venue? = nil
        
        Alamofire.request(.POST, server.URL, parameters: parameters).responseJSON { response in
            switch response.result{
            case .Success:
                if let value = response.result.value{
                    
                    let json = JSON(value)
                    if json["success"] {
                        self.handler.updateMapForVenue(venue, data: json["data"]["image_data_url"].string!)
                        completion(result: true)
                    } else {
                        print(json["data"][0]["message"])
                        completion(result: false)
                    }
                }
                
            case .Failure(let error):
                print(error.localizedDescription)
                completion(result: false)
                
            }
            
        }

    }
    
    func getMyEventDataFromAPI(group: dispatch_group_t, inout isDispatchEmpty: Bool, completion: (Bool) -> Void){
        let paramaters = [
            "api_key": server.KEY,
            "app_secret": server.SECRET,
            "method" : "getEventsByTag",
            "tag_name" : "testTag"
        ] //at the moment the api call need event id
        
        Alamofire.request(.POST, server.URL, parameters: paramaters).responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    //self.handler.deleteEventsData()
                    
                    for i in 0 ..< json["data"].count {
                        dispatch_group_enter(group)
                        let event = self.handler.addNewEvent(json["data"][i], attending: "1")
                        
//                        APIManager().getPoster(event, group: group){
//                            self.handler.performUpdate()
//                        }
                    }
                }
                completion(true)
            case .Failure(let error):
                print(error.localizedDescription)
                let notification = MPGNotification(title: "No internet Connection", subtitle: "Data might not updated.", backgroundColor: UIColor.orangeColor(), iconImage: nil)
                notification.show()
                completion(false)
            }
            
        }
    }
    
    
    func getUserFromAPI(email:String, completion: (result: Bool) -> Void) {
        
        let paramaters = [
            "api_key"	:	server.KEY,
            "app_secret":	server.SECRET,
            "method"	:	"getUser",
            "venue_id"	:	email //email?
        ]
        var user:User? = nil
        
        Alamofire.request(.POST, server.URL, parameters: paramaters).responseJSON {response in
            switch response.result{
            case .Success:
                if let value = response.result.value{
                    
                    let json = JSON(value)
                    if json["success"] {
                        user = self.handler.addNewUser(json["data"][0])
                        
                        //self.handler.saveVenueForEvent(event, venue:venue!)
                        completion(result: true)
                    } else {
                        print(json["data"][0]["message"])
                        completion(result: false)
                    }
                }
                
            case .Failure(let error):
                print(error.localizedDescription)
                completion(result: false)
                
            }
            
        }
        
    }
    
    func getUsersForConversationFromAPI(conversation:Conversation, completion: (result: Bool) -> Void)
    {
        guard let id = conversation.conversation_id else {
            completion(result: false)
            return
        }
        
        let paramaters = [
            "api_key"	:	server.KEY,
            "app_secret":	server.SECRET,
            "method"	:	"getConversationParticipants",
            "conversation_id"	:	id
        ]
        
        Alamofire.request(.POST, server.URL, parameters: paramaters).responseJSON {response in
            switch response.result{
            case .Success:
                if let value = response.result.value{
                    
                    let json = JSON(value)
                    if json["success"] {
                        if let counter = json["data"].array?.count
                        {
                            if counter < 2 {
                                print("counter should not be < 2")
                            }
                            for i in 0..<counter
                            {
                                if let user:User = self.handler.addNewUser(json["data"][i])
                                {
                                    self.handler.saveUserForConversation(user, conversation: conversation)
                                }else {
                                    //get the user
                                    let email:String = json["data"][i]["email"].string!
                                    let user = self.handler.getUser(email)
                                    //save user for conversation
                                    self.handler.saveUserForConversation(user!, conversation: conversation)
                                }
                            }
                        }
                        
                        //user?.mutableSetValueForKey("conversations").addObject(conversation)
                        //conversation.mutableSetValueForKey("users").addObject(user!)
                        
                        //self.handler.saveVenueForEvent(event, venue:venue!)
                        completion(result: true)
                    } else {
                        print(json["data"][0]["message"])
                        completion(result: false)
                    }
                }
                
            case .Failure(let error):
                print(error.localizedDescription)
                completion(result: false)
                
            }
            
        }

    }
    
    func getConversationsFromAPI(email:String, group: dispatch_group_t, inout isDispatchEmpty: Bool, completion: (Bool) -> Void) {
    
        let paramaters = [
            "api_key"	:	server.KEY,
            "app_secret":	server.SECRET,
            "method"	:	"getConversationsByUser",
            "email"	:	email
        ]
        
        Alamofire.request(.POST, server.URL, parameters: paramaters).responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    //self.handler.deleteEventsData()
                    let counter = json["data"].count
                    for i in 0 ..< counter {
                        dispatch_group_enter(group)
                        print(json["data"][i])
                        self.handler.addNewConversation(json["data"][i])
                        self.handler.performUpdate()
                        dispatch_group_leave(group)
                    }
                }
                completion(true)
            case .Failure(let error):
                print(error.localizedDescription)
                let notification = MPGNotification(title: "No internet Connection", subtitle: "Data might not updated.", backgroundColor: UIColor.orangeColor(), iconImage: nil)
                notification.show()
                completion(false)
            }
            
        }
    }
    
    func getConversationsByUserForEventFromAPI(email:String, eventID:String, group: dispatch_group_t, inout isDispatchEmpty: Bool, completion: (Bool) -> Void)    {
        
        let paramaters = [
            "api_key"	:	server.KEY,
            "app_secret":	server.SECRET,
            "method"	:	"getConversationsByUserForEvent",
            "email"	:	email,
            "event_id" : eventID
        ]
        
        Alamofire.request(.POST, server.URL, parameters: paramaters).responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    if (json["data"]["message"].string != nil)
                    {
                        print(json["data"]["message"].string)
                        
                    }else{
                        //self.handler.deleteEventsData()
                        let counter = json["data"].count
                        for i in 0 ..< counter {
                            dispatch_group_enter(group)
                            //print(json["data"][i])
                            self.handler.addNewConversation(json["data"][i])
                            self.handler.performUpdate()
                            dispatch_group_leave(group)
                        }
                    }
                }
                completion(true)
            case .Failure(let error):
                print(error.localizedDescription)
                let notification = MPGNotification(title: "No internet Connection", subtitle: "Data might not updated.", backgroundColor: UIColor.orangeColor(), iconImage: nil)
                notification.show()
                completion(false)
            }
            
        }

    }
    
    
    func getMessagesForConversation(conversation:Conversation, completion: (result: Bool) -> Void){
        guard let id = conversation.conversation_id else {
            completion(result: false)
            return
        }
        
        let parameters = [
            "api_key": server.KEY,
            "app_secret": server.SECRET,
            "method" : "getConversation",
            "conversation_id" : id
        ]
        
        var message:Message? = nil
        
        Alamofire.request(.POST, server.URL, parameters: parameters).responseJSON { response in
            switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        if json["success"]{
							//print("JSON COUNT: \(json["data"].count)")
                            for i in 0 ..< json["data"].count {
                                message = self.handler.addNewMessage(json["data"][i], conversation: conversation)
                                //self.handler.saveMessageForConversation(conversation, message: message!)
                            }
                            completion(result: true)
                        } else {
                            completion(result: false)
                        }
                    }
                            
                case .Failure(let error):
                            print(error.localizedDescription)
                            completion(result: false)
            }
        
        }
    }
    
    func getLatestMessageDateForConversation(conversation:Conversation, completion: (result: NSDate?) -> Void) {
        guard let id = conversation.conversation_id else {
            completion(result: nil)
            return
        }
        
        let parameters = [
            "api_key": server.KEY,
            "app_secret": server.SECRET,
            "method" : "getLatestMessage",
            "conversation_id" : id
        ]
        
        Alamofire.request(.POST, server.URL, parameters: parameters).responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    if json["success"]{
                        //print("JSON COUNT: \(json["data"].count)")
//                        latestMessage.content = json["data"]["content"].string
//                        latestMessage.sender_email = json["data"]["sender_email"].string
//                        latestMessage.date = ModelHandler().serverStringToDate(json["data"]["date"].string!)
                        //print("message: \(json["data"]["message_id"].string) \(json["data"]["content"].string) from \(json["data"]["sender_email"].string)")
                        let latestMessageDate = ModelHandler().serverStringToDate(json["data"]["date"].string!)
                        
                        completion(result: latestMessageDate)
                    } else {
                        completion(result: nil)
                    }
                }
                
            case .Failure(let error):
                print(error.localizedDescription)
                completion(result: nil)
            }
            
        }


    }
    
    func sendMessage(email:String, content:String, conversationID:String, completion: (result: Bool) -> ())
    {
        let parameters = [
            "api_key": server.KEY,
            "app_secret": server.SECRET,
            "method" : "sendMessage",
            "conversation_id" : conversationID,
            "sender_email" : email,
            "content" : content
        ]
        
        Alamofire.request(.POST, server.URL, parameters: parameters).responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    if json["success"]{
                        print("message sent successfully")
                        completion(result: true)
                    } else {
                        print("message failed to send")
                        completion(result: false)
                    }
                }
                
            case .Failure(let error):
                print(error.localizedDescription)
                completion(result: false)
            }
        }
    }
    
//    func getMessagesForConvo(convo: Conversation, group: dispatch_group_t, completion: () -> Void)
//    {
//        guard let id = convo.conversation_id else {
//            //print(id)
//            return
//        }
//        let parameters = [
//            "api_key": server.KEY,
//            "app_secret": server.SECRET,
//            "method" : "getConversation",
//            "conversation_id" : id
//        ]
//        
//        let message_queue = dispatch_queue_create("message_queue", nil)
//        dispatch_async(message_queue, {
//            Alamofire.request(.POST, self.server.URL, parameters: parameters).responseJSON(){ response in
//                switch response.result{
//                case .Success:
//                    if let value = response.result.value {
//                        let json = JSON(value)
//                        print(json["data"])
//                        let counter = json["data"].count
//                        for i in 0 ..< counter{
//                            print(json["data"][i])
//                            let message = self.handler.addNewMessage(json["data"][i])
//                            self.handler.performUpdate()
//                        }
//
//                    }
//                    
//                    dispatch_group_leave(group)
//                    completion()
//                    
//                case .Failure(let error):
//                    dispatch_group_leave(group)
//                    print(error.localizedDescription)
//                    completion()
//                }
//            }
//        })
//
//    }
    
//    func getMyMessagesFromAPI()
//    {
//        //getConversationsByUser(email) -> conversation_id
//            //self.handler.addNewConversation
//        //getConversation(conversation_id) ->
//            //self.handler.addNewMessage
//    }



}

//MARK: Event Dashboard
extension APIManager{
	func scanQR(ticket_id : String, completion: (result: Bool, data: JSON) -> Void){
		let parameters = [
			"api_key"	:	server.KEY,
			"app_secret":	server.SECRET,
			"method"	:	"getTicketAndUser",
			"ticket_id"	:	ticket_id,
		]
		
		Alamofire.request(.POST, server.URL, parameters: parameters).responseJSON { response in
			switch response.result{
			case .Success:
				if let value = response.result.value{
					
					let json = JSON(value)
					HUD.hide()
					if json["success"] {
						completion(result: true, data: json["data"][0])
					} else {
						print(json["data"][0]["message"])
						completion(result: false, data: nil)
					}
				}
				
			case .Failure(let error):
				HUD.hide()
				print(error.localizedDescription)
				let notification = MPGNotification(title: "No internet Connection", subtitle: "Data might not be the latest.", backgroundColor: UIColor.orangeColor(), iconImage: nil)
				notification.show()
				completion(result: false, data: nil)
				
			}
			
		}
		
	}
	
	func getPurchasedTicket(email: String, event_id : String, completion: (result: Bool, data: JSON) -> Void){
		let parameters = [
			"api_key"	:	server.KEY,
			"app_secret":	server.SECRET,
			"method"	:	"getUserTicketsForEvent",
			"event_id"	:	event_id,
			"email"		:	email
		]
		
		Alamofire.request(.POST, server.URL, parameters: parameters).responseJSON { response in
			switch response.result{
			case .Success:
				if let value = response.result.value{
					
					let json = JSON(value)
					HUD.hide()
					if json["success"] {
						print(json["data"])
						completion(result: true, data: json["data"][0])
					} else {
						print(json["data"][0]["message"])
						completion(result: false, data: nil)
					}
				}
				
			case .Failure(let error):
				HUD.hide()
				print(error.localizedDescription)
				let notification = MPGNotification(title: "No internet Connection", subtitle: "Data might not be the latest.", backgroundColor: UIColor.orangeColor(), iconImage: nil)
				notification.show()
				completion(result: false, data: nil)
				
			}
			
		}
	}
}