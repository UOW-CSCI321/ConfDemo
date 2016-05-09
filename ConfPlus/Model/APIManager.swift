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
	
	
	
	func getExploreDataFromAPI(group: dispatch_group_t, inout isDispatchEmpty: Bool, completion: (Bool) -> Void){
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
						let event = self.handler.addNewEvent(json["data"][i])
				
						dispatch_group_enter(group)
						APIManager().getPoster(event, group: group){ result in
							self.handler.performUpdate()
						}
					}
					completion(true)
				}
			case .Failure(let error):
				print(error.localizedDescription)
				let notification = MPGNotification(title: "No internet Connection", subtitle: "Data might not updated.", backgroundColor: UIColor.orangeColor(), iconImage: nil)
				notification.show()
				completion(false)
			}
			
		}
	}

	func getPoster(event: Event, group: dispatch_group_t, completion: (Bool) -> Void){
		guard let id = event.event_id else {
			return
		}
		
		let paramaters = [
			"api_key": server.KEY,
			"app_secret": server.SECRET,
			"method" : "getPoster",
			"event_id" : id
		]
		
		let poster_queue = dispatch_queue_create("poster_queue", nil)
		dispatch_async(poster_queue, {
			Alamofire.request(.POST, self.server.URL, parameters: paramaters).responseJSON(){ response in
				switch response.result{
				case .Success:
					if let value = response.result.value {
						let json = JSON(value)
						event.poster_url = json["data"]["poster_data_url"].string
						
						print("updated image")
						
						dispatch_group_leave(group)
						completion(true)
					} else {
						dispatch_group_leave(group)
						completion(false)
					}
				case .Failure(let error):
					dispatch_group_leave(group)
					print(error.localizedDescription)
					completion(false)
				}
			}
		})
		
	}
	
	
	

	func getVenue(event:Event, completion: (result: Bool) -> Void) {
		guard let id = event.venue_id else {
			completion(result: false)
			return
		}
		
		let paramaters = [
			"api_key"	:	server.KEY,
			"app_secret":	server.SECRET,
			"method"	:	"getVenue",
			"venue_id"	:	id
		]
		var venue:Venue? = nil
		
		Alamofire.request(.POST, server.URL, parameters: paramaters).responseJSON {response in
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

}


//Mark: Login and Register
extension APIManager{
	func register(email : String, password : String, username:String, completion: (result: Bool) -> Void){
		let paramaters = [
			"api_key"	:	server.KEY,
			"app_secret":	server.SECRET,
			"method"	:	"createUser",
			"email"		:	email,
			"password"	:	password,
			"username"	:	username
		]
		
		Alamofire.request(.POST, server.URL, parameters: paramaters).responseJSON {response in
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
		let paramaters = [
			"api_key"	:	server.KEY,
			"app_secret":	server.SECRET,
			"method"	:	"login",
			"email"		:	email,
			"password"	:	password
		]
		
		HUD.show(.Progress)
		
		Alamofire.request(.POST, server.URL, parameters: paramaters).responseJSON {response in
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
}