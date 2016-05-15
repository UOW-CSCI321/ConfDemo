//
//  MessengerViewController.swift
//  ConfPlus
//
//  Created by Matthew Boroczky on 15/05/2016.
//  Copyright © 2016 Conf+. All rights reserved.
//

import Foundation
import UIKit
import MPGNotification
import JSQMessagesViewController

class MessengerViewController: JSQMessagesViewController {
    
    var messages = [[Message]]()
    var conversationID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("conversationid: \(conversationID)")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    
}

