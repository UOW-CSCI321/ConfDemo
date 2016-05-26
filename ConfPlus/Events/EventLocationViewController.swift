//
//  MapViewController.swift
//  confDemo
//
//  Created by CY Lim on 15/03/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import Foundation
import UIKit

class EventLocationViewController:UIViewController {
    
    @IBOutlet var mapImageView: UIImageView!
    var event:Event!
    var venue:Venue?
    
	@IBAction func dismissLocationView(sender: AnyObject) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        print(event.venue_id)
    }
}