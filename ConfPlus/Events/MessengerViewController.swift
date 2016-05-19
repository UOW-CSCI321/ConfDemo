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
    var dateTextAttributes:NSDictionary = [:]
    var timeTextAttributes:NSDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("conversationid: \(conversationID)")
        let bgColour = UIColor(white: 0.85, alpha: 1.0)
        let txtColour = UIColor(white: 0.60, alpha: 1.0)
        let systFont = UIFont.systemFontOfSize(14/*, weight:10*/)
        
        //setup for date
        var color: UIColor = UIColor.lightGrayColor()
        var paragraphStyle: NSMutableParagraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.alignment = .Center
        
        
        
        dateTextAttributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(12.0), NSForegroundColorAttributeName: color, NSParagraphStyleAttributeName: paragraphStyle]
        timeTextAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(12.0), NSForegroundColorAttributeName: color, NSParagraphStyleAttributeName: paragraphStyle]
        
        systemProfilePic = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials("cf+", backgroundColor: bgColour, textColor: txtColour, font: systFont, diameter: 30)
        setupBubbles()
//        setupAvatarsArray()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        //yesterday
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "GMT")
        
        let d1 = dateFormatter.dateFromString("2016-05-16 16:35:00") //dateString	String	"2016-05-01 16:35:00"
        //self.attributedTimestampForDate(d1)
        let d2 = dateFormatter.dateFromString("2016-05-17 16:35:00")
        let d3 = dateFormatter.dateFromString("2016-05-19 14:36:00")
        
        
        // messages from someone else
        addMessage("michael@test.com", displayName: "michael", date: d1!, text: "Hey person!")
        // messages sent from local sender
        addMessage(senderId, displayName: "matt", date: d2!, text: "Yo!")
        addMessage(senderId, displayName: "matt", date: d3!, text: "I like turtles!")
        addMessage("system", displayName: "system", date:d3!, text: "the presentation on 'mobile applications' will start in 15 minutes'")
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
    
    override func collectionView(collectionView: UICollectionView,
                                 cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
            as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView!.textColor = UIColor.whiteColor()
        } else {
            cell.textView!.textColor = UIColor.blackColor()
        }
        print(cell.messageBubbleTopLabel.attributedText)
        return cell
    }
    
    func addMessage(id: String, displayName:String, date:NSDate, text: String) {
        //let today = NSDate()
        let m = JSQMessage(senderId: id, senderDisplayName: displayName, date: date, text: text)
        //let message = JSQMessage(senderId: id, displayName: displayName, text: text)
        messages.append(m)
        //print(m) //data is setting properly
    }
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath) -> NSAttributedString? {
        /**
         *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
         *  The other label text delegate methods should follow a similar pattern.
         *
         *  Show a timestamp for every 3rd message
         */
        //if indexPath.item % 3 == 0 {
            var message: JSQMessage = messages[indexPath.item]
            
            if(indexPath.item != 0)
            {
                //print(messages)
                print("index: \(messages[indexPath.item].date), index-1: \(messages[indexPath.item - 1].date)")
//                let previousMessage = messages[indexPath.item - 1]
//                
//                //see if the date is the same but not the time
//                //            let dcf = NSDateComponentsFormatter()
//                //            dcf.unitsStyle = NSDateComponentsFormatterUnitsStyle.Full
//                //
//                //            let interval = message.date.timeIntervalSinceDate(previousMessage.date)
//                //            dcf.stringFromTimeInterval(interval)
//                //            let days = dcf.
//                print("prev: \(previousMessage.date)")
//                print("curr: \(message.date)")
//                
                var order = NSCalendar.currentCalendar().compareDate(messages[indexPath.item - 1].date, toDate: message.date, toUnitGranularity: .Day)
                switch order {
                case .OrderedSame:
                    print("same")
                case .OrderedAscending, .OrderedDescending:
                    print("asc or desc")
                default:
                    print("def")
                    
                }

            }
            
            
            print(message.date)
            
            let attributedstring = attributedTimestampForDate(message.date) //my function returns australian format
            //let a = JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date) //returns american format
            
            return attributedstring
        /*}
        return nil*/
    }
    
    //This function is a copied and modified version of the function attributedTimestampForDate in JSQMessagesTimestampFormatter
    //I needed to modify the function so that the date returned is in the australian format not the american
    func attributedTimestampForDate(date: NSDate?) -> NSAttributedString? {
        if (date == nil) {
            //return nil
        }
        
        //get date and time into seperate strings for GMT
        let df = NSDateFormatter()
        df.dateFormat = "dd/MM/yy"
        df.timeZone = NSTimeZone(name: "GMT")
        let dstring = df.stringFromDate(date!)
        df.dateStyle = NSDateFormatterStyle.NoStyle
        df.timeStyle = NSDateFormatterStyle.ShortStyle
        let tstring = df.stringFromDate(date!)
        
        
//        var relativeDate: String = self.relativeDateForDate(date)
//        var time: String = self.timeForDate(date)
//        var timestamp: NSMutableAttributedString = NSMutableAttributedString(string: relativeDate, attributes: self.dateTextAttributes)
        var timestamp: NSMutableAttributedString = NSMutableAttributedString(string: dstring, attributes: self.dateTextAttributes as! [String : AnyObject])
        
        timestamp.appendAttributedString(NSAttributedString(string: " "))
        timestamp.appendAttributedString(NSAttributedString(string: tstring, attributes: self.timeTextAttributes as! [String : AnyObject]))
        //print(timestamp)
        return NSAttributedString(attributedString: timestamp)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        /**
         *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
         */
        /**
         *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
         *  The other label height delegate methods should follow similarly
         *
         *  Show a timestamp for every 3rd message
         */
        if indexPath.item % 3 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        return 0.0
    }
    
    
    // View  usernames above bubbles
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item];
        
        // Sent by me, skip
        if message.senderId == senderId {
            return nil;
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderId == message.senderId {
                return nil;
            }
        }
        
        return NSAttributedString(string: message.senderDisplayName)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let message = messages[indexPath.item]
        
        // Sent by me, skip
        if message.senderId == senderId {
            return CGFloat(0.0);
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderId == message.senderId {
                return CGFloat(0.0);
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
}

