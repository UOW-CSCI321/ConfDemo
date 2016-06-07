//
//  InviteTable.swift
//  ConfPlus
//
//  Created by Matthew Boroczky on 7/06/2016.
//  Copyright © 2016 Conf+. All rights reserved.
//

import Foundation
import UIKit
class InviteTable : NSObject, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("inviteTableViewCell", forIndexPath: indexPath) as! inviteTableViewCell
        let row = indexPath.row
        
        cell.inviteLabel.text = "test"
        cell.inviteImageView.image = UIImage(named: "michael")
        
        return cell
    }
}