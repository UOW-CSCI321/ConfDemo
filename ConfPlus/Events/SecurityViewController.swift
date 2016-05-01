//
//  SecurityViewController.swift
//  confDemo
//
//  Created by Matthew Boroczky on 15/03/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import Foundation
import UIKit

class SecurityViewController: UIViewController {
	
	@IBOutlet weak var helpView: UIView!
	
	@IBAction func dismissSecurityView(sender: AnyObject) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		viewEffect.round(helpView)
    }
    
}