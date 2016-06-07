//
//  SecurityViewController.swift
//  confDemo
//
//  Created by Matthew Boroczky on 15/03/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import Foundation
import UIKit
import Localize_Swift

class SecurityViewController: UIViewController {
	
	@IBOutlet weak var helpButton: UIButton!
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
	
	override func viewWillAppear(animated: Bool) {
		setText()
	}
	
    @IBAction func helpPressed(sender: AnyObject) {
        if let num = event.security_num
        {
            if num != ""
            {
                var url:NSURL = NSURL(string: "tel:\(num)")!
                UIApplication.sharedApplication().openURL(url)
            }else {
                showAlert("warnSecurity".localized(), message: "warnSecurityMessage".localized())
            }
            
        }else {
            showAlert("warnSecurity".localized(), message: "warnSecurityMessage".localized())
        }
        
        
    }
	
	func setText(){
		helpButton.setTitle("Help".localized(), forState: .Normal)
	}
    
    func showAlert(title: String, message:String="warnTryAgain".localized()){
        let alertcontroller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK".localized(), style: .Default, handler: nil)
        alertcontroller.addAction(defaultAction)
        self.presentViewController(alertcontroller, animated: true, completion: nil)
    }

}