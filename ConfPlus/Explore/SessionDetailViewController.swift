//
//  SessionDetailViewController.swift
//  ConfPlus
//
//  Created by CY Lim on 2/06/2016.
//  Copyright © 2016 Conf+. All rights reserved.
//

import UIKit
import PKHUD

struct Topic {
	var email: String
	var speakerName: String
	var topic: String
	var room: String
	var description: String
}


class SessionDetailViewController: UITableViewController {
	
	@IBOutlet weak var avatar: UIImageView!
	@IBOutlet weak var labelSpeakerName: UILabel!
	@IBOutlet weak var labelTopicName: UILabel!
	@IBOutlet weak var labelRoom: UILabel!
	@IBOutlet weak var textViewDescription: UITextView!
	
	var event:Event!
	var ticket:Tickets!
	var topic:Topic!
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		populateSessionDetail()
	}
	
	func populateSessionDetail(){
		HUD.show(.Progress)
			APIManager().getSession(self.event.event_id!, title: self.ticket.title!){ result, json in
				if result{
					let data = json!["data"]
					
					self.topic = Topic(email: data["speaker_email"].string ?? "",
					                   speakerName: "",
					                   topic: data["title"].string ?? "",
					                   room: data["room_name"].string ?? "",
					                   description: data["description"].string ?? "")
					
				}
		}
		
		self.populateDataIntoTableView()
		
		for section in 0..<self.tableView.numberOfSections {
			self.shouldHideSection(section)
		}
		HUD.hide()
		self.tableView.reloadData()
		
		
	}
	
	func getSpeakerInfo(completion: (result:Bool) -> ()){
		APIManager().getUser(self.topic.email, completion: { result, json in
			if result {
				let data = json!["data"]
				self.topic.speakerName = "\(data["first_name"].string!) \(data["last_name"].string!)"
			} else {
				completion(result: false)
			}
			
		})
	}
	
	func populateDataIntoTableView(){
		if topic.email != "" {
			getSpeakerInfo(){ result in
				if result {
					//avatar.image =
					self.labelSpeakerName.text = self.topic.speakerName
				}
			}
		}
		
		labelTopicName.text = topic.topic
		labelRoom.text = topic.room
		if topic.description != "" {
			textViewDescription.text = topic.description
		}
	}
	
}

//MARK:- TableView Helpers Function
extension SessionDetailViewController {
	func shouldHideSection(section: Int) -> Bool {
		switch section {
		case 0:
			return topic.email == "" ? true : false
		case 2:
			return topic.description == "" ? true : false
		default:
			return false
		}
	}
	
	// Hide Header(s)
	override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return shouldHideSection(section) ? 0.1 : super.tableView(tableView, heightForHeaderInSection: section)
	}
	
	// Hide footer(s)
	override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return shouldHideSection(section) ? 0.1 : super.tableView(tableView, heightForFooterInSection: section)
	}
	
	// Hide rows in hidden sections
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return shouldHideSection(indexPath.section) ? 0 : super.tableView(tableView, heightForRowAtIndexPath: indexPath)
	}
	
	// Hide header text by making clear
	override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		if shouldHideSection(section) {
			let headerView = view as! UITableViewHeaderFooterView
			headerView.textLabel!.textColor = UIColor.clearColor()
		}
	}
	
	// Hide footer text by making clear
	override func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
		if shouldHideSection(section) {
			let footerView = view as! UITableViewHeaderFooterView
			footerView.textLabel!.textColor = UIColor.clearColor()
		}
	}
}