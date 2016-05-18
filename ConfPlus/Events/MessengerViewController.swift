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
    
    var messages = [JSQMessage]()
    var avatars = [JSQMessagesAvatarImage]()
    var conversationID = ""
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    var systemProfilePic: JSQMessagesAvatarImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("conversationid: \(conversationID)")
        let bgColour = UIColor(white: 0.85, alpha: 1.0)
        let txtColour = UIColor(white: 0.60, alpha: 1.0)
        let systFont = UIFont.systemFontOfSize(14/*, weight:10*/)
        systemProfilePic = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials("cf+", backgroundColor: bgColour, textColor: txtColour, font: systFont, diameter: 30)
        setupBubbles()
//        setupAvatarsArray()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // messages from someone else
        addMessage("michael@test.com", displayName: "michael", text: "Hey person!")
        // messages sent from local sender
        addMessage(senderId, displayName: "matt", text: "Yo!")
        addMessage(senderId, displayName: "matt", text: "I like turtles!")
        addMessage("system", displayName: "system", text: "the presentation on 'mobile applications' will start in 15 minutes'")
        // animates the receiving of a new message on the view
        finishReceivingMessage()
    }
    
    func getImageForEmail(email:String) -> JSQMessagesAvatarImage //matt defined
    {
        //this will set the images from coredata
        if email == "matt3@test.com"
        {
            //image
            let i1 = UIImage(named:"matt")
            let idefault = UIImage(named:"account2")
            let d = UInt((i1?.size.width)!/2)
            
            //circular
            let circular = JSQMessagesAvatarImageFactory.circularAvatarImage(i1, withDiameter: d)
            
            let i = JSQMessagesAvatarImage(avatarImage: circular, highlightedImage: i1, placeholderImage: idefault)
            return i
        }else if email == "michael@test.com"
        {
            let i1 = UIImage(named:"michael")
            let idefault = UIImage(named:"account2")
            let i = JSQMessagesAvatarImage(avatarImage: i1, highlightedImage: i1, placeholderImage: idefault)
            return i
        }else{
            return self.systemProfilePic
        }
        
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    private func setupBubbles() {
        let factory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageView = factory.outgoingMessagesBubbleImageWithColor(
            UIColor.jsq_messageBubbleBlueColor())
        incomingBubbleImageView = factory.incomingMessagesBubbleImageWithColor(
            UIColor.jsq_messageBubbleLightGrayColor())
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == senderId { //check if message was sent by local user
            return outgoingBubbleImageView
        } else { // if not local user return incoming message
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = self.messages[indexPath.item]
//        if message.senderId == self.senderId
//        {
//            
//        }
//        return nil
        let avatar = getImageForEmail(message.senderId)

        return avatar
    }
    
    func addMessage(id: String, displayName:String, text: String) {
        let today = NSDate()
        let m = JSQMessage(senderId: id, senderDisplayName: displayName, date: today, text: text)
        //let message = JSQMessage(senderId: id, displayName: displayName, text: text)
        messages.append(m)
        //print(m) //data is setting properly
    }
}

