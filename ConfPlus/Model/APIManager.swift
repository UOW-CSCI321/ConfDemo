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

class APIManager{
	
	let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
	let server = APIServer()
	let handler = ModelHandler()
	
	
	
	func getExploreDataFromAPI(group: dispatch_group_t, inout isDispatchEmpty: Bool){
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
					
					self.handler.deleteEventsData()
					
					for i in 0 ..< json["data"].count {
						let event = self.handler.addNewEvent(json["data"][i])
				
						dispatch_group_enter(group)
						APIManager().getPoster(event, group: group, isDispatchEmpty: &isDispatchEmpty)
					}
				}
			case .Failure(let error):
				print(error.localizedDescription)
				let notification = MPGNotification(title: "No internet Connection", subtitle: "Data might not updated.", backgroundColor: UIColor.orangeColor(), iconImage: nil)
				notification.show()
			}
			
		}
	}

	func getPoster(event: Event, group: dispatch_group_t, inout isDispatchEmpty: Bool){
		let id:NSNumber = event.event_id!
		let paramaters = [
			"api_key": server.KEY,
			"app_secret": server.SECRET,
			"method" : "getPoster",
			"event_id" : id
		]
		
		let poster_queue = dispatch_queue_create("poster_queue", nil)
		dispatch_async(poster_queue, {
			isDispatchEmpty = false
			Alamofire.request(.POST, self.server.URL, parameters: paramaters).responseJSON(){ response in
				switch response.result{
				case .Success:
					if let value = response.result.value {
						let json = JSON(value)
						event.poster_url = json["data"]["poster_data_url"].string
						
						print("updated image")
						self.handler.performUpdate()
					}
					dispatch_group_leave(group)
				case .Failure(let error):
					dispatch_group_leave(group)
					print(error.localizedDescription)
				}
			}
		})
		
	}
}