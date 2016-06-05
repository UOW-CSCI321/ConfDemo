//
//  APIManager-Ticketing.swift
//  ConfPlus
//
//  Created by CY Lim on 28/05/2016.
//  Copyright © 2016 Conf+. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import Alamofire
import SwiftyJSON
import MPGNotification
import PKHUD

extension APIManager{
	
	func getEventTickets(event_id:String, completion: (result: Bool, json: JSON?) -> Void){
		let parameters = [
			"api_key": server.KEY,
			"app_secret": server.SECRET,
			"method" : "getEventTickets",
			"event_id" : event_id
		] //at the moment the api call need event id
		
		Alamofire.request(.POST, server.URL, parameters: parameters).responseJSON { response in
			switch response.result {
			case .Success:
				if let value = response.result.value {
					let json = JSON(value)
					if json["success"]{
						completion(result: true, json: json)
					} else {
						completion(result: false, json: nil)
					}
				}
				
			case .Failure(let error):
				print(error.localizedDescription)
				self.fetchError()
				completion(result: false, json: nil)
			}
			
		}
	}
	
	func getSessions(event_id:String, completion: (result: Bool, json: JSON?) -> Void){
		let parameters = [
			"api_key": server.KEY,
			"app_secret": server.SECRET,
			"method" : "getSessions",
			"event_id" : event_id
		] //at the moment the api call need event id
		
		Alamofire.request(.POST, server.URL, parameters: parameters).responseJSON { response in
			switch response.result {
			case .Success:
				if let value = response.result.value {
					let json = JSON(value)
					if json["success"]{
						completion(result: true, json: json)
					} else {
						completion(result: false, json: nil)
					}
				}
			
			case .Failure(let error):
				print(error.localizedDescription)
				self.fetchError()
				completion(result: false, json: nil)
			}
		
		}
	}
    
    func getUserTicketsForEvent(event_id:String, email:String, completion: (result: Bool, json: JSON?) -> Void)
    {
        let parameters = [
            "api_key": server.KEY,
            "app_secret": server.SECRET,
            "method" : "getUserTicketsForEvent",
            "event_id" : event_id,
            "email" : email
        ]
        
        Alamofire.request(.POST, server.URL, parameters: parameters).responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    //print(json)
                    if json["success"]{
                        completion(result: true, json: json)
                    } else {
                        completion(result: false, json: nil)
                    }
                }
                
            case .Failure(let error):
                print(error.localizedDescription)
                self.fetchError()
                completion(result: false, json: nil)
            }
            
        }

    }
}