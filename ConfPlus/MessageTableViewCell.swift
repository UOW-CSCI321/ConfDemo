//
//  MessageTableViewCell.swift
//  ConfPlus
//
//  Created by Matthew Boroczky on 11/05/2016.
//  Copyright © 2016 Conf+. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var usersName: UILabel!
    @IBOutlet var messageDescription: UILabel!
    @IBOutlet var messageDateLabel: UILabel!
    @IBOutlet var seenImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        usersName.font = UIFont.systemFontOfSize(18)
        messageDescription.font = UIFont.systemFontOfSize(14)
        messageDateLabel.font = UIFont.systemFontOfSize(16)
        
        messageDescription.textColor = UIColor.darkGrayColor()
        messageDateLabel.textColor = UIColor.darkGrayColor()
        
        addCellLineSeperator()
        makeImageCircle(profilePicture, onlineStatus: "online")
        addSeenImage()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func makeImageCircle(imgv:UIImageView, onlineStatus:String)
    {
        var onlineColour : UIColor = UIColor(red: 0.42, green: 0.92, blue: 0.04, alpha: 1)
        var offlineColour : UIColor = UIColor(red: 0.99, green: 0.29, blue: 0.01, alpha: 1)
        
        imgv.layer.cornerRadius = imgv.frame.size.width/2
        imgv.clipsToBounds = true
        imgv.layer.borderWidth = 3.0
        if(onlineStatus == "online")
        {
            imgv.layer.borderColor = onlineColour.CGColor
        }else{
            imgv.layer.borderColor = offlineColour.CGColor
        }
        
    }
    func addCellLineSeperator()
    {
        let dividerLineView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(white:0.5, alpha:0.5)
            return view
        }()
        
        addSubview(dividerLineView)
        
        addConstraintsWithFormat("H:|-82-[v0]|", views: dividerLineView)
        addConstraintsWithFormat("V:[v0(1)]|", views: dividerLineView)
    }
    
    func addSeenImage()
    {
        seenImage.layer.cornerRadius = 10
        seenImage.layer.masksToBounds = true
        seenImage.image = UIImage(named:"matt")
    }
}

extension UIView {
    func addConstraintsWithFormat(format:String, views: UIView...)
    {
        var viewsDictionary = [String: UIView]()
        for(index, view) in views.enumerate()
        {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}