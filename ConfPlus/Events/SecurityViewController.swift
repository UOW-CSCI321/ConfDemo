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
    var event:Event!
	
	@IBAction func dismissSecurityView(sender: AnyObject) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        print(event.security_num)
		
		viewEffect.round(helpView)
    }
    @IBAction func helpPressed(sender: AnyObject) {
        var url:NSURL = NSURL(string: "tel:123456789")!
        UIApplication.sharedApplication().openURL(url)
    }
    
    func showAlert(title: String, message:String="Please try again"){
        let alertcontroller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertcontroller.addAction(defaultAction)
        self.presentViewController(alertcontroller, animated: true, completion: nil)
    }

}