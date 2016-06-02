//
//  SessionDetailViewController.swift
//  ConfPlus
//
//  Created by CY Lim on 2/06/2016.
//  Copyright © 2016 Conf+. All rights reserved.
//

import UIKit
import PKHUD

class SessionDetailViewController: UITableViewController {
	
	@IBOutlet weak var avatar: UIImageView!
	@IBOutlet weak var labelSpeakerName: UIView!
	@IBOutlet weak var labelTopicName: UIView!
	@IBOutlet weak var labelVenue: UILabel!
	@IBOutlet weak var labelRoom: UIView!
	@IBOutlet weak var textViewDescription: UITextView!
	
	
	var event:Event!
	var ticket:Tickets!

    override func viewDidLoad() {
        super.viewDidLoad()
		
		populateSessionDetail()
    }
	
	func populateSessionDetail(){
		//TODO: API Request
	}
}

//MARK:- TableView Helpers Funciton
extension SessionDetailViewController {
	func shouldHideSection(section: Int) -> Bool {
		switch section {
		case 0:
			//return user!.isProvider() ? false : true
			return true
		case 2:
			return true
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