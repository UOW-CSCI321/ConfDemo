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
						self.user.setObject(json["data"][0]["title"].string, forKey: "title")
						self.user.setObject(json["data"][0]["first_name"].string, forKey: "firstName")
						self.user.setObject(json["data"][0]["last_name"].string, forKey: "lastName")
						self.user.setObject(json["data"][0]["dob"].string, forKey: "birthday")
						self.user.setObject(json["data"][0]["street"].string, forKey: "street")
						self.user.setObject(json["data"][0]["city"].string, forKey: "city")
						self.user.setObject(json["data"][0]["state"].string, forKey: "state")
						self.user.setObject(json["data"][0]["country"].string, forKey: "country")
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