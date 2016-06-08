//
//  ExploreTableViewCell.swift
//  ConfPlus
//
//  Created by CY Lim on 19/03/2016.
//  Copyright © 2016 Conf+. All rights reserved.
//

import UIKit
import HCSStarRatingView

class EventsTableViewCell: UITableViewCell {
	
	
	@IBOutlet weak var eventCell: UIView!
	
	@IBOutlet weak var eventImage: UIImageView!
	@IBOutlet weak var eventName: UILabel!
	@IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var starsView: UIView!
    var rating:HCSStarRatingView!
    var ratinngInt:Int!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
		viewEffect.rect(eventCell)
        
        rating = HCSStarRatingView()
        rating.minimumValue = 0
       
        rating.maximumValue = 5
        rating.allowsHalfStars = false
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
    
    @IBAction func didChangeValue(sender: HCSStarRatingView) {
        ratinngInt = Int(sender.value)
        
        let val = sender.value
        print("value changed to \(ratinngInt)")
    }
    
    func getRating() -> Int {
        return self.ratinngInt
    }
	
}
