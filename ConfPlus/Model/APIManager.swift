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
	
	func getExploreDataFromAPI(group: dispatch_group_t, inout isDispatchEmpty: Bool, completion: (Bool) -> Void){
		let parameters = [
			"api_key": server.KEY,
			"app_secret": server.SECRET,
			"method" : "getEventsByTag",
			"tag_name" : "testTag"
		] //at the moment the api call need event id
		
		Alamofire.request(.POST, server.URL, parameters: parameters).responseJSON { response in
			switch response.result {
			case .Success:
				if let value = response.result.value {
					let json = JSON(value)
					
					//self.handler.deleteEventsData()
					
					for i in 0 ..< json["data"].count {
						dispatch_group_enter(group)
						let event = self.handler.addNewEvent(json["data"][i], attending: "0")
						
						APIManager().getPoster(event, group: group){
							self.handler.performUpdate()
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

	func getPoster(event: Event, group: dispatch_group_t, completion: () -> Void){
		guard let id = event.event_id else {
			//print(id)
			return
		}
		let parameters = [
			"api_key": server.KEY,
			"app_secret": server.SECRET,
			"method" : "getPoster",
			"event_id" : id
		]
		
		let poster_queue = dispatch_queue_create("poster_queue", nil)
		dispatch_async(poster_queue, {
			Alamofire.request(.POST, self.server.URL, parameters: parameters).responseJSON(){ response in
				switch response.result{
				case .Success:
					if let value = response.result.value {
						let json = JSON(value)
						event.poster_url = json["data"]["poster_data_url"].string
						
						print("updated image")
						
					}
					
					dispatch_group_leave(group)
					completion()
					
				case .Failure(let error):
					dispatch_group_leave(group)
					print(error.localizedDescription)
					completion()
				}
			}
		})
		
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
                        
                        APIManager().getPoster(event, group: group){
                            self.handler.performUpdate()
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
    
    
    func getUserFromAPI(email:String, completion: (result: Bool) -> Void) {
        
        let paramaters = [
            "api_key"	:	server.KEY,
            "app_secret":	server.SECRET,
            "method"	:	"getUser",
            "venue_id"	:	email
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
                        
//                        APIManager().getMessagesForConvo(convo, group: group){
//                            self.handler.performUpdate()
//                        }
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
    
    func getMessagesForConversation(conversationID:String, completion: (result: Bool) -> Void){
        let parameters = [
            "api_key": server.KEY,
            "app_secret": server.SECRET,
            "method" : "getConversation",
            "conversation_id" : conversationID
        ]
        
        Alamofire.request(.POST, server.URL, parameters: parameters).responseJSON { response in
            switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        if json["success"]{
                            for i in 0 ..< json["data"].count {
                                //self.handler.addNewEvent(json["data"][i], attending: "1")
                                self.handler.addNewMessage(json["data"][i])
                            }
                            completion(result: true)
                        } else {
                            //self.fetchError("Life is short", message:"Go to Explore Tab and join some interesting events.")
                            completion(result: false)
                        }
                    }
                            
                case .Failure(let error):
                            print(error.localizedDescription)
                            //self.fetchError()
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


//MARK: Login and Register
extension APIManager{
	func register(email : String, password : String, username:String, completion: (result: Bool) -> Void){
		let parameters = [
			"api_key"	:	server.KEY,
			"app_secret":	server.SECRET,
			"method"	:	"createUser",
			"email"		:	email,
			"password"	:	password,
			"username"	:	username
		]
		
		Alamofire.request(.POST, server.URL, parameters: parameters).responseJSON { response in
			switch response.result{
			case .Success:
				if let value = response.result.value{
					
					let json = JSON(value)
					HUD.hide()
					if json["success"] {
						HUD.flash(.Success, delay: 1.0)
						completion(result: true)
					} else {
						print(json["data"][0]["message"])
						completion(result: false)
					}
				}
				
			case .Failure(let error):
				HUD.hide()
				print(error.localizedDescription)
				let notification = MPGNotification(title: "No internet Connection", subtitle: "Data might not be the latest.", backgroundColor: UIColor.orangeColor(), iconImage: nil)
				notification.show()
				completion(result: false)
				
			}
			
		}
		
	}
	
	
	func login(email : String, password : String, completion: (result: Bool) -> Void) {
		let parameters = [
			"api_key"	:	server.KEY,
			"app_secret":	server.SECRET,
			"method"	:	"login",
			"email"		:	email,
			"password"	:	password
		]
		
		HUD.show(.Progress)
		
		Alamofire.request(.POST, server.URL, parameters: parameters).responseJSON { response in
			switch response.result{
			case .Success:
				if let value = response.result.value{
					
					let json = JSON(value)
					HUD.hide()
					if json["success"] {
						HUD.flash(.Success, delay: 1.0)
						completion(result: true)
					} else {
						print(json["data"][0]["message"])
						completion(result: false)
					}
				}
				
			case .Failure(let error):
				HUD.hide()
				print(error.localizedDescription)
				let notification = MPGNotification(title: "No internet Connection", subtitle: "Data might not updated.", backgroundColor: UIColor.orangeColor(), iconImage: nil)
				notification.show()
				completion(result: false)
				
			}
			
		}
	}
	
	func getUserInformation(email:String, completion: (result: Bool, data:JSON) -> ()){
		let parameters = [
			"api_key"	:	server.KEY,
			"app_secret":	server.SECRET,
			"method"	:	"getUser",
			"email"	:	email
		]
		
		HUD.show(.Progress)
		Alamofire.request(.POST, server.URL, parameters: parameters).responseJSON { response in
			switch response.result{
			case .Success:
				if let value = response.result.value{
					
					let json = JSON(value)
					if json["success"] {
						HUD.hide()
						let data = json["data"][0]
						print(data)
						self.user.setObject(data["title"].string, forKey: "title")
						self.user.setObject(data["first_name"].string, forKey: "firstName")
						self.user.setObject(data["last_name"].string, forKey: "lastName")
						self.user.setObject(data["dob"].string, forKey: "birthday")
						self.user.setObject(data["street"].string, forKey: "street")
						self.user.setObject(data["city"].string, forKey: "city")
						self.user.setObject(data["state"].string, forKey: "state")
						self.user.setObject(data["country"].string, forKey: "country")
						self.user.synchronize()
						
						completion(result: true, data: json["data"][0])
					} else {
						HUD.hide()
						print(json["data"][0]["message"])
						completion(result: false, data: nil)
					}
				}
			case .Failure(let error):
				HUD.hide()
				print(error.localizedDescription)
				let notification = MPGNotification(title: "No internet Connection", subtitle: "Data might not updated.", backgroundColor: UIColor.orangeColor(), iconImage: nil)
				notification.show()
				completion(result: false, data: nil)
			}
		}
	}

	func updateProfile(email: String, title: String?, first_name:String?, last_name:String?, dob:String?, street:String?, city:String?, state:String?, country:String?, completion:(result:Bool) -> ()){
		var parameters = [
			"api_key"	:	server.KEY,
			"app_secret":	server.SECRET,
			"method"	:	"updateUser",
			"email"		:	email
		]
		
		if let title = title { parameters["title"] = title }
		if let first_name = first_name { parameters["first_name"] = first_name }
		if let last_name = last_name { parameters["last_name"] = last_name }
		if let dob = dob {
			if dob == "" {
				parameters["dob"] = "1970-12-31 00:00"
			} else {
				parameters["dob"] = dob + " 00:00"
			}
		}
		if let street = street { parameters["street"] = street }
		if let city = city { parameters["city"] = city }
		if let state = state { parameters["state"] = state }
		if let country = country { parameters["country"] = country }
		
		print(parameters)
		
		HUD.show(.Progress)
		
		Alamofire.request(.POST, server.URL, parameters: parameters).responseJSON { response in
			switch response.result{
			case .Success:
				if let value = response.result.value{
					
					let json = JSON(value)
					HUD.hide()
					if json["success"] {
						HUD.flash(.Success, delay: 1.0)
						completion(result: true)
					} else {
						print(json["data"][0]["message"])
						completion(result: false)
					}
				}
				
			case .Failure(let error):
				HUD.hide()
				print(error.localizedDescription)
				let notification = MPGNotification(title: "No internet Connection", subtitle: "Data might not updated.", backgroundColor: UIColor.orangeColor(), iconImage: nil)
				notification.show()
				completion(result: false)
				
			}
			
		}
	}
	
	func getPaymentHistory(email: String, completion: (result:Bool) -> ()){
		let paramaters = [
			"api_key"	:	server.KEY,
			"app_secret":	server.SECRET,
			"method"	:	"getPaymentHistory",
			"email"		:	email
		]
		
		Alamofire.request(.POST, server.URL, parameters: paramaters).responseJSON { response in
			switch response.result{
			case .Success:
				if let value = response.result.value{
					
					let json = JSON(value)
					if json["success"] {
						for i in 0 ..< json["data"].count {
							self.handler.addNewPaymentHistory(json["data"][i])
						}
						completion(result: true)
					} else {
						print(json["data"][0]["message"])
						completion(result: false)
					}
				}
				
			case .Failure(let error):
				print(error.localizedDescription)
				let notification = MPGNotification(title: "No internet Connection", subtitle: "Data might not updated.", backgroundColor: UIColor.orangeColor(), iconImage: nil)
				notification.show()
				completion(result: false)
				
			}
			
		}
	}
}