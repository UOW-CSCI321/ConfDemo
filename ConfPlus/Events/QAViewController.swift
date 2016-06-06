//
//  QAViewController.swift
//  ConfPlus
//
//  Created by Matthew Boroczky on 1/06/2016.
//  Copyright © 2016 Conf+. All rights reserved.
//

import Foundation
import UIKit
import MPGNotification
import JSQMessagesViewController

class QAViewController: JSQMessagesViewController {
    
    var messages = [JSQMessage]()
    var avatars = [JSQMessagesAvatarImage]()
    var conversationID = ""
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    var failedOutgoingBubbleImageView: JSQMessagesBubbleImage!
    var systemProfilePic: JSQMessagesAvatarImage!
    var dateTextAttributes:NSDictionary = [:]
    var timeTextAttributes:NSDictionary = [:]
    //var messagesCollectionViewFlowLayout = AnyObject.self
    var cellIndexPathForCustomHeight = NSIndexPath()
    var timeIsOpen = [Bool]()
    var returnHeight:CGFloat = 0.0
    //var refresher: UIRefreshControl!
    var isDispatchEmpty:Bool = true
    var databaseMessages = [Message]()
    var conversation:Conversation!
    var failedMessages = [Int]() //position of the failed message in messages
    var users = [User]()
    var bgColour = UIColor()
    var txtColour = UIColor()
    var systFont = UIFont()
    var timer = NSTimer()
    
    var session:Session!
    var userEmail:String!
    var speakerIncomingBubbleImageView: JSQMessagesBubbleImage!
    var speakerEmail:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.inputToolbar.contentView.leftBarButtonItem = nil //remove accessorry button
        bgColour = UIColor(white: 0.85, alpha: 1.0)
        txtColour = UIColor(white: 0.60, alpha: 1.0)
        systFont = UIFont.systemFontOfSize(14/*, weight:10*/)
        
        //setup for date
        var color: UIColor = UIColor.lightGrayColor()
        var paragraphStyle: NSMutableParagraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.alignment = .Center
        
        dateTextAttributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(12.0), NSForegroundColorAttributeName: color, NSParagraphStyleAttributeName: paragraphStyle]
        timeTextAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(12.0), NSForegroundColorAttributeName: color, NSParagraphStyleAttributeName: paragraphStyle]
        //
        
        systemProfilePic = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials("cf+", backgroundColor: bgColour, textColor: txtColour, font: systFont, diameter: 30)
        setupBubbles()
//
//        
//        
//        users = ModelHandler().getUsersForConversation(conversation)!
//        //getMessagesFromAPI() //should be called from viewWillAppear but breaking
//        databaseMessages = ModelHandler().getMessageForConversation(conversation)!
//        //^ returns empty array first time
//        messagesToJSQMessages()
        
        //here we want to pull messages for sessions where title = tile and event_id = event id - in vdl
    }
    
    func messagesToJSQMessages() //converts array of cordata messages to array of JSQMessages
    {
        var count = databaseMessages.count
        var usercount = self.users.count
        
        if count > 0
        {
            //whipe all messages we have so far to get messages again
            messages = [JSQMessage]()
            //iterate through database messages and create objects and add them to the JSQMessages array
            //print(databaseMessages[0])
            for i in 0..<count
            {
                //var user = databaseMessages[i].sender
                //                var dname:String = (user?.first_name)! //we cant use user as the only user we store locally is users loggedin
                //                dname += " "
                //                dname += (user?.last_name)!
                
                var dname = ""
                for j in 0..<usercount
                {
                    if users[j].email == databaseMessages[i].sender_email
                    {
                        dname = users[j].first_name!
                        dname += " "
                        dname += users[j].last_name!
                        addMessage(databaseMessages[i].sender_email!, displayName: dname, date: databaseMessages[i].date!, text: databaseMessages[i].content!)
                        
                    }
                }
                
                if dname == ""
                {
                    addMessage(databaseMessages[i].sender_email!, displayName: databaseMessages[i].sender_email!, date: databaseMessages[i].date!, text: databaseMessages[i].content!)
                }
            }
            finishSendingMessage()
        }
    }
    
    
    func getMessagesFromAPI() {
        if isDispatchEmpty {
            isDispatchEmpty = false
            let notification = MPGNotification(title: "Updating", subtitle: "it might takes some time for updating.", backgroundColor: UIColor.orangeColor(), iconImage: nil)
            notification.show()
            
            APIManager().getMessagesForConversation(conversation){ result in
                dispatch_async(dispatch_get_main_queue()) {
                    notification.hidden = true
                    self.isDispatchEmpty = true
                    self.databaseMessages = ModelHandler().getMessageForConversation(self.conversation)!
                    print("MESSAGE COUNT: \(self.databaseMessages.count)")
                    //print(self.databaseMessages)
                    self.messagesToJSQMessages()
                }
            }
        }
    }
    
    func getLatestServerMessage() {
        APIManager().getLatestMessageDateForConversation(self.conversation) { result in
            //let sm = result
            //var count = self.databaseMessages.count
            //count - 1 //count is from 1..n not 0.n
            let sDate = result //sm.date
            //            for i in 0..<count
            //            {
            //                print("\(i) \(self.databaseMessages[i])")
            //            }
            let msg = self.databaseMessages.last
            let dDate = msg?.date
            
            //print("message: \(msg!.content) from \(msg!.sender_email)")
            
            var order = NSCalendar.currentCalendar().compareDate(dDate!, toDate: sDate!, toUnitGranularity: .Second)
            switch order {
            case .OrderedSame:
                //local database is up to date with the server
                print("up to date already")
            case .OrderedDescending:
                //local database holds a message later than server
                print("database updated > server")
            case .OrderedAscending:
                //local data base does not have the latest message
                print("need to update")
                self.getMessagesFromAPI()
                
            }
            
        }
        
    }
    
    func addConvoForSession() {
        APIManager().getAddConversationidForSession(self.session.event_id!, title: self.session.title!) { result, convo_id in
            if convo_id != nil{
                print(convo_id)
                //need to get Conversation not conversation id
                APIManager().getConversation(convo_id!) { result in
                    print("here")
                   //get from model
                    let convoArrayOf1 = ModelHandler().getAConversation(convo_id!)
                    self.conversation = convoArrayOf1[0]
                    print(self.conversation.conversation_id)
                    
                    //ModelHandler().getUser(self.userEmail)
                    //THE CONVERSATION HAS NOW BEEN SAVED
                    //api manager get users from conversation (Conversation)
                    APIManager().getUsersForConversationFromAPI(self.conversation) { result in //this should add profile pics of users getting from server
                        //print(result)
                        //NOT SURE IF SAVING USERS FOR CONVERSATION -IS SAVING
                        self.users =  ModelHandler().getUsersForConversation(self.conversation)!
                        //print(self.users)
                        self.getMessagesFromAPI()
                    }
                    
                }
                
                //get user
                    //add relationship between user and conversation
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.timer.invalidate()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        addConvoForSession()
        
        //timer
        timer = NSTimer.scheduledTimerWithTimeInterval(60.0, target: self, selector: "getLatestServerMessage", userInfo: nil, repeats: true)
//
        
//        getMessagesFromAPI()
        
        //yesterday
        //        let dateFormatter = NSDateFormatter()
        //        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //        dateFormatter.timeZone = NSTimeZone(name: "GMT")
        //
        //        let d1 = dateFormatter.dateFromString("2016-05-16 16:35:00") //dateString	String	"2016-05-01 16:35:00"
        //        //self.attributedTimestampForDate(d1)
        //        let d2 = dateFormatter.dateFromString("2016-05-17 16:35:00")
        //        let d3 = dateFormatter.dateFromString("2016-05-19 14:36:00")
        
        
        // messages from someone else
        //        addMessage("michael@test.com", displayName: "michael", date: d1!, text: "Hey person!")
        //        // messages sent from local sender
        //        addMessage(senderId, displayName: "matt", date: d2!, text: "Yo!")
        //        addMessage(senderId, displayName: "matt", date: d3!, text: "I like turtles!")
        //        addMessage("system", displayName: "system", date:d3!, text: "the presentation on 'mobile applications' will start in 15 minutes'")
        //        // animates the receiving of a new message on the view
        //        finishReceivingMessage()
    }
    
    func getImageForEmail(email:String, indexPathItem:Int) -> JSQMessagesAvatarImage //matt defined
    {
        //i don't think index path means anything
        let c = self.users.count
        //print("self.user.count: \(c)")
        //print("email': \(email)")
        
        let idefault = UIImage(named:"account2")
        
        for i in 0..<c
        {
            if self.users[i].email == email //we found a match
            {
                if self.users[i].profile_pic_url != nil
                {
                    let img = self.users[i].getImage()
                    let d = UInt((img.size.width)/2) //diameter
                    
                    //circular
                    let circular = JSQMessagesAvatarImageFactory.circularAvatarImage(img, withDiameter: d)
                    
                    let avatar = JSQMessagesAvatarImage(avatarImage: circular, highlightedImage: img, placeholderImage: idefault)
                    
                    return avatar
                    
                }else{
                    //since they don't have a profile picture return the system default type
                    
                    //get first character of firstname
                    var f = self.users[indexPathItem].first_name!
                    var indexStartOfText = f.startIndex.advancedBy(1)
                    f = f.substringToIndex(indexStartOfText)
                    
                    //get first character of last name
                    var l = self.users[indexPathItem].last_name!
                    indexStartOfText = l.startIndex.advancedBy(1)
                    l = l.substringToIndex(indexStartOfText)
                    
                    let ppString =  f + l
                    
                    let avatar = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials(ppString, backgroundColor: bgColour, textColor: txtColour, font: systFont, diameter: 30)
                    
                    return avatar
                }
                
                
                
            }
        }
        //        if self.users[indexPathItem].profile_pic_url == nil
        //        {
        //            var f = self.users[indexPathItem].first_name!
        //            let indexStartOfText = f.startIndex.advancedBy(1)
        //            f = f.substringToIndex(indexStartOfText)
        //
        //            let pic = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials("cf+", backgroundColor: bgColour, textColor: txtColour, font: systFont, diameter: 30)
        //        }
        
        
        //        //this will set the images from coredata
        //        if email == "matt3@test.com"
        //        {
        //            //image
        //            let i1 = UIImage(named:"matt")
        //            let idefault = UIImage(named:"account2")
        //            let d = UInt((i1?.size.width)!/2)
        //
        //            //circular
        //            let circular = JSQMessagesAvatarImageFactory.circularAvatarImage(i1, withDiameter: d)
        //
        //            let i = JSQMessagesAvatarImage(avatarImage: circular, highlightedImage: i1, placeholderImage: idefault)
        //            return i
        //        }else if email == "michael@test.com"
        //        {
        //            let i1 = UIImage(named:"michael")
        //            let idefault = UIImage(named:"account2")
        //            let i = JSQMessagesAvatarImage(avatarImage: i1, highlightedImage: i1, placeholderImage: idefault)
        //            return i
        //        }else{
        //            return self.systemProfilePic
        //        }
        
        return self.systemProfilePic
        
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
        
        failedOutgoingBubbleImageView = factory.outgoingMessagesBubbleImageWithColor(
            UIColor.jsq_messageBubbleRedColor())
        speakerIncomingBubbleImageView = factory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
    }

    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == senderId { //check if message was sent by local user
            if self.failedMessages.contains(indexPath.item)
            {
                return failedOutgoingBubbleImageView
            }
            return outgoingBubbleImageView
        } else { // if not local user return incoming message
            if message.senderId == speakerEmail
            {
                return speakerIncomingBubbleImageView
            }
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
        let avatar = getImageForEmail(message.senderId, indexPathItem: indexPath.item)
        
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
        //print(cell.messageBubbleTopLabel.attributedText)
        return cell
    }
    
    func addMessage(id: String, displayName:String, date:NSDate, text: String) {
        let m = JSQMessage(senderId: id, senderDisplayName: displayName, date: date, text: text)
        //let message = JSQMessage(senderId: id, displayName: displayName, text: text)
        messages.append(m)
        //print(messages.count)
        
        //add time not open to the time array
        let b = false
        timeIsOpen.append(b)
    }

    func sendMessageByAPI(email:String, conversation_id:String, content:String)
    {
        if isDispatchEmpty {
            isDispatchEmpty = false
            
            APIManager().sendMessage(email, content: content, conversationID: conversation_id){ result in
                if result == true
                {
                    //return true
                    print("true")
                    //if message sent successful playmessagesentsound
                    JSQSystemSoundPlayer.jsq_playMessageSentSound()
                }else
                {
                    //return false
                    print("false")
                    let failedMessageIndex = self.messages.count - 1 //we just added this message to the array and now its failed
                    self.failedMessages.append(failedMessageIndex)
                    //change colour
                }
                self.isDispatchEmpty = true
                self.finishSendingMessage()
            }
        }
        
    }

    //send message
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        
        addMessage(senderId, displayName: senderDisplayName, date: date, text: text)
        //send the message we just added to the JSQMessage array
        sendMessageByAPI(senderId, conversation_id: self.conversation.conversation_id!, content: text)
    }
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath) -> NSAttributedString? {
        /**
         *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
         *  The other label text delegate methods should follow a similar pattern.
         *
         *  Show a timestamp for every 3rd message - change to show for every cell that is a new date
         */
        //if indexPath.item % 3 == 0 {
        var message: JSQMessage = messages[indexPath.item]
        
        if(indexPath.item != 0)
        {
            //print("index: \(messages[indexPath.item].date), index-1: \(messages[indexPath.item - 1].date)")
            var order = NSCalendar.currentCalendar().compareDate(messages[indexPath.item - 1].date, toDate: message.date, toUnitGranularity: .Day)
            switch order {
            case .OrderedSame:
                return nil
            case .OrderedAscending, .OrderedDescending:
                // let attributedstring = attributedTimestampForDate(message.date) //my function returns australian format
                let attributedstring = JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
                //print("date: \(message.date) converted to \(attributedstring)")
                return attributedstring
            }
            
        }else if indexPath.item == 0 //first
        {
            //let attributedstring = attributedTimestampForDate(message.date) //my function returns australian format
            let attributedstring = JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
            //print("date: \(message.date) converted to \(attributedstring)")
            return attributedstring
        }
        return nil
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        /**
         *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
         */
        /**
         *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
         *  The other label height delegate methods should follow similarly
         *
         *  Show a timestamp for every 3rd message - change to show for every cell that is a new date
         */
        
        var message: JSQMessage = messages[indexPath.item]
        //print(indexPath.item)
        
        if(indexPath.item != 0)
        {
            //print("index: \(messages[indexPath.item].date), index-1: \(messages[indexPath.item - 1].date)")
            var order = NSCalendar.currentCalendar().compareDate(messages[indexPath.item - 1].date, toDate: message.date, toUnitGranularity: .Day)
            switch order {
            case .OrderedSame:
                return 0.0
            case .OrderedAscending, .OrderedDescending:
                return kJSQMessagesCollectionViewCellLabelHeightDefault
            }
            
        }else if indexPath.item == 0 //first
        {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        return 0.0
    }
    
    //This is incorrect as dates on the server are stored as gmt and displayed as gmt+10 not stored as gmt+10 on server
    //This function is a copied and modified version of the function attributedTimestampForDate in JSQMessagesTimestampFormatter
    //I needed to modify the function so that the date returned is in the australian format not the american
    //    func attributedTimestampForDate(date: NSDate?) -> NSAttributedString? {
    //        if (date == nil) {
    //            return nil
    //        }
    //
    //        //get date and time into seperate strings for GMT
    //        let df = NSDateFormatter()
    //        df.dateFormat = "dd/MM/yy"
    //        df.timeZone = NSTimeZone(name: "GMT")
    //        let dstring = df.stringFromDate(date!)
    //        df.dateStyle = NSDateFormatterStyle.NoStyle
    //        df.timeStyle = NSDateFormatterStyle.ShortStyle
    //        let tstring = df.stringFromDate(date!)
    //
    //
    //        var timestamp: NSMutableAttributedString = NSMutableAttributedString(string: dstring, attributes: self.dateTextAttributes as! [String : AnyObject])
    //        timestamp.appendAttributedString(NSAttributedString(string: " "))
    //        timestamp.appendAttributedString(NSAttributedString(string: tstring, attributes: self.timeTextAttributes as! [String : AnyObject]))
    //        return NSAttributedString(attributedString: timestamp)
    //    }
    
    
    // View  usernames above bubbles
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item];
        
        // Sent by me, skip
        if message.senderId == senderId {
            if self.failedMessages.contains(indexPath.item)
            {
                //print("we found a failed message: \(message.text)")
                return NSAttributedString(string: "Messaged failed to send")
            }
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
            if self.failedMessages.contains(indexPath.item)
            {
                return kJSQMessagesCollectionViewCellLabelHeightDefault
            }
            
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
    
    override func collectionView(collectionView: JSQMessagesCollectionView, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath) {
        self.cellIndexPathForCustomHeight = indexPath //.item //this is the message that we want to change the height for
        
        
        if timeIsOpen[indexPath.item]
        {
            timeIsOpen[indexPath.item] = false
            returnHeight = 0.0
        }
        else{
            timeIsOpen[indexPath.item] = true
            returnHeight =  kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        
        
        
        finishReceivingMessage() //this will load the collection view
        //print("Tapped message bubble!")
    }
    
    //copy function of whats in cocoapod that just returns time not formatted
    func timeForDate(date: NSDate?) -> String? {
        if date == nil {
            return nil
        }
        let df = NSDateFormatter()
        df.dateStyle = NSDateFormatterStyle.NoStyle
        df.timeStyle = NSDateFormatterStyle.ShortStyle
        return df.stringFromDate(date!)
    }

    func attributedTimesForDate(date: NSDate?) -> NSAttributedString? {
        if date == nil {
            return nil
        }
        var relativeDate: String = ""
        var time: String = timeForDate(date)!
        let timestamp: NSMutableAttributedString = NSMutableAttributedString(string: relativeDate, attributes: dateTextAttributes as! [String : AnyObject])
        timestamp.appendAttributedString(NSAttributedString(string: " "))
        timestamp.appendAttributedString(NSAttributedString(string: time, attributes: timeTextAttributes as! [String : AnyObject]))
        return NSAttributedString(attributedString: timestamp)
    }
    //
    
    //functions for message bottom label
    override func collectionView(collectionView: JSQMessagesCollectionView, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath) -> NSAttributedString? {
        //return nil
        let message = messages[indexPath.item];
        let date = message.date
        
        //let attributedstring = JSQMessagesTimestampFormatter.sharedFormatter().timeForDate(date)
        //NO USE CUSTOM FUNC
        let attributedstring = attributedTimesForDate(date)
        
        return attributedstring
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellBottomLabelAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //print("global indxpath: \(self.cellIndexPathForCustomHeight)")
        //print("indexpath: \(indexPath)")
        //print("indexpath.item: \(indexPath.item)")
        
        if indexPath == self.cellIndexPathForCustomHeight //if the cell we are looking at is the one for the customer height
        {
            return returnHeight
        }else {
            return 0.0
        }
    }
    
    
}

