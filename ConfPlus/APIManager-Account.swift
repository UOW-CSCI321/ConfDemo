//
//  APIManager-Account.swift
//  ConfPlus
//
//  Created by CY Lim on 3/06/2016.
//  Copyright © 2016 Conf+. All rights reserved.
//

import Foundation
import Alamofire
import PKHUD
import MPGNotification
import SwiftyJSON

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
				HUD.flash((.Label("No Internet Connection")), delay: 1)
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
				HUD.flash((.Label("No Internet Connection")), delay: 1)
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
				HUD.flash((.Label("No Internet Connection")), delay: 1)
				completion(result: false, data: nil)
			}
		}
	}
	
	//func getUserProfilePicFromAPI
	func getUserProfilePicFromAPI(user:User, completion: (result: Bool) -> Void){
		guard let email = user.email else {
			print("No email", #function)
			return
		}
		let parameters = [
			"api_key": server.KEY,
			"app_secret": server.SECRET,
			"method" : "getProfileImage",
			"email" : email
		]
		
		Alamofire.request(.POST, self.server.URL, parameters: parameters).responseJSON(){ response in
			switch response.result{
			case .Success:
				if let value = response.result.value {
					let json = JSON(value)
					//print(json)
					if json["success"]{
						//self.handler.updatePosterForEvent(event, data: json["data"]["poster_data_url"].string!)
						self.handler.updateUsersProfilePic(user, data: json["data"]["image_data_url"].string!)
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
	
	func updateProfile(email: String, title: String?, first_name:String?, last_name:String?, dob:String?, street:String?, city:String?, state:String?, country:String?, completion:(result:Bool) -> ()){
		var parameters = [
			"api_key"	:	server.KEY,
			"app_secret":	server.SECRET,
			"method"	:	"updateUser",
			"email"		:	email,
			"verified"	:	"1",
			"fb_id"		:	"",
			"linkedin_id":	"",
			"active"	:	"",
			"upgraded"	:	"",
			"review"	:	"0",
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
				HUD.flash((.Label("No Internet Connection")), delay: 1)
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
				HUD.flash((.Label("No Internet Connection")), delay: 1)
				completion(result: false)
				
			}
			
		}
	}
	
	
	func createBillingInfo(email: String, card:String, type:String, date:String, completion: (result:Bool) -> ()){
		let paramaters = [
			"api_key"	:	server.KEY,
			"app_secret":	server.SECRET,
			"method"	:	"createBillingInfo",
			"email"		:	email,
			"card#"		:	card,
			"card_type"	:	type,
			"expiry_date":	date
		]
		
		Alamofire.request(.POST, server.URL, parameters: paramaters).responseJSON { response in
			switch response.result{
			case .Success:
				if let value = response.result.value{
					
					let json = JSON(value)
					if json["success"] {
						completion(result: true)
					} else {
						print(json["data"][0]["message"])
						completion(result: false)
					}
				}
				
			case .Failure(let error):
				print(error.localizedDescription)
				HUD.flash(.Label("No Internet Connection"), delay: 1)
				completion(result: false)
				
			}
			
		}
	}
}