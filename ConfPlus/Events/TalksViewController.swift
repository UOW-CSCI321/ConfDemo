//
//  TalksViewController.swift
//  confDemo
//
//  Created by Matthew Boroczky on 15/03/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//


import UIKit
import PKHUD


class TalksViewController: UITableViewController {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var labelSpeakerName: UILabel!
    @IBOutlet weak var labelTopicName: UILabel!
    @IBOutlet weak var labelRoom: UILabel!
    @IBOutlet weak var textViewDescription: UITextView!
    
    var event:Event!
    var ticket:Tickets!
    var topic = Topic()
    
    var mySession:Session!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        HUD.show(.Progress)
        //APIManager().getSession(self.event.event_id!, title: self.ticket.title!){ result, json in
            //if result{
//                let data = json!["data"][0]
//                
//                self.topic = Topic(email: data["speaker_email"].string,
//                                   speakerName: nil,
//                                   topic: data["title"].string,
//                                   room: data["room_name"].string,
//                                   description: data["description"].string)
        print(mySession.session_description)
        self.topic = Topic(email: self.mySession.speaker_email,
                           speakerName: nil,
                           topic: self.mySession.title,
                           room: self.mySession.room_name,
                           description: self.mySession.session_description)
        
        if self.mySession.speaker_email != nil {
            //get user from model handler before getting from api
            //TODO ^
            APIManager().getUserInformation(self.mySession.speaker_email!, completion: { result, json in
                if result {
                    //let data = json["data"][0]
                    print(json["first_name"].string)
                    //print(data)
                    
                    self.topic.speakerName = "\(json["first_name"].string!) \(json["last_name"].string!)"
                    self.labelSpeakerName.text = self.topic.speakerName
                    
                    //get profile image
                    if let myself = ModelHandler().getUser(self.mySession.speaker_email!) {
                        APIManager().getUserProfilePicFromAPI(myself) { result in
                            print("here")
                        }
                    }

                    
                    self.update()
                }
            })
        } else {
            self.update()
        }
        
//                if self.topic.email != nil {
//                    APIManager().getUser(self.topic.email!, completion: { result, json in
//                        if result {
//                            let data = json!["data"][0]
//                            self.topic.speakerName = "\(data["first_name"].string!) \(data["last_name"].string!)"
//                            self.labelSpeakerName.text = self.topic.speakerName
//                            
//                            self.update()
//                        }
//                    })
//                } else {
//                    self.update()
//                }
           // }
        //}
    }
    
    func update(){
        self.labelTopicName.text = self.topic.topic
        self.labelRoom.text = self.topic.room
        if self.topic.description != "" {
            self.textViewDescription.text = self.topic.description
        }
        
        for section in 0..<self.tableView.numberOfSections {
            self.shouldHideSection(section)
        }
        HUD.hide()
        self.tableView.reloadData()
    }
    
}

//MARK:- TableView Helpers Function
extension TalksViewController {
    func shouldHideSection(section: Int) -> Bool {
        switch section {
        case 0:
            return self.topic.email == nil ? true : false
        case 2:
            return self.topic.description == nil ? true : false
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