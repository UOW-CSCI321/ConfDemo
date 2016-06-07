//
//  TalksViewController.swift
//  confDemo
//
//  Created by Matthew Boroczky on 15/03/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//


import UIKit
import PKHUD
import MPGNotification


class TalksViewController: UITableViewController {
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var topicLabel: UILabel!
	@IBOutlet weak var roomLabel: UILabel!
	@IBOutlet weak var talkButton: UIButton!
	
	
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var labelSpeakerName: UILabel!
    @IBOutlet weak var labelTopicName: UILabel!
    @IBOutlet weak var labelRoom: UILabel!
    @IBOutlet weak var textViewDescription: UITextView!
    
    var event:Event!
    var ticket:Tickets!
    var topic = Topic()
    var segment:UISegmentedControl!
    
    var mySession:Session!
    let user = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        HUD.show(.Progress)
        
        self.topic = Topic(email: self.mySession.speaker_email,
                           speakerName: nil,
                           topic: self.mySession.title,
                           room: self.mySession.room_name,
                           description: self.mySession.session_description)
        
        if self.mySession.speaker_email != nil {
            //get user from model handler before getting from api
            if let myself = ModelHandler().getUser(self.mySession.speaker_email!) {
                self.avatar.image = myself.getImage()
                GeneralLibrary().makeImageCircle(self.avatar)
                self.update()
            }
        } else {
            self.update()
        }
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
		setText()
        if self.mySession.speaker_email != nil {
            
            let notification = MPGNotification(title: "Updating", subtitle: "it might takes some time for updating.", backgroundColor: UIColor.orangeColor(), iconImage: nil)
            notification.duration = 60
            notification.show()
            
            //from api
            APIManager().getUserInformation(self.mySession.speaker_email!, completion: { result, json in
                if result {
                    //let data = json["data"][0]
                    //print(json["first_name"].string)
                    //print(data)
                    print(json)
                    if json["first_name"].string == nil {
                        print("ERROR: speaker has not had their name set")
                    }else{
                        self.topic.speakerName = "\(json["first_name"].string!) \(json["last_name"].string!)"
                        self.labelSpeakerName.text = self.topic.speakerName
                        
                        //get profile image
                        if let myself = ModelHandler().getUser(self.mySession.speaker_email!) {
                            APIManager().getUserProfilePicFromAPI(myself) { result in
                                if let myself2 = ModelHandler().getUser(self.mySession.speaker_email!) {
                                    self.avatar.image = myself2.getImage()
                                    GeneralLibrary().makeImageCircle(self.avatar)
                                    notification.hidden = true
                                }
                            }
                        }
                    }
                    self.update()
                }
            })
        } else {
            self.update()
        }
        self.tableView.reloadData()
    }
	
	func setText(){
		navigationItem.title = "Details".localized()
		
		nameLabel.text = "Name".localized()
		topicLabel.text = "Topic".localized()
		roomLabel.text = "Room".localized()
		
		talkButton.setTitle("Talk".localized(), forState: .Normal)
        if self.segment.selectedSegmentIndex == 1{
            talkButton.hidden = true
        }
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc:QAViewController = segue.destinationViewController as! QAViewController
        vc.session = self.mySession
        
        vc.senderId = user.stringForKey("email")
        vc.userEmail = user.stringForKey("email")
        
        var title:String = self.topic.topic!
        
        //title = "123456789123456789123456789123456789"
        //handles long names
        if title.characters.count > 23 { //27
            let n = title.characters.count
            var numGoBack = title.characters.count - 23
            numGoBack -= (numGoBack + numGoBack)
            let r = title.startIndex.advancedBy(0)..<title.endIndex.advancedBy(numGoBack)
            
            title = title.substringWithRange(r)
            title += "... Q&A"
        }else{
            title += " Q&A"
        }
        
        vc.title = title
        vc.senderDisplayName = "test"
        vc.speakerEmail = self.mySession.speaker_email
       
        self.hidesBottomBarWhenPushed = true
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
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return "Speaker Information".localized()
		} else if section == 1 {
			return "Session Information".localized()
		} else if section == 2 {
			return "Description".localized()
		}
		return ""
	}
}