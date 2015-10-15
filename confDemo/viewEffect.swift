//
//  viewEffect.swift
//  confDemo
//
//  Created by CY Lim on 2015/10/08.
//  Copyright © 2015年 CY Lim. All rights reserved.
//

import UIKit

class viewEffect: NSObject {
    
    class func rect(buttonView: UIView) -> Void {
        buttonView.layer.cornerRadius = 8
        buttonView.layer.masksToBounds = false;
        buttonView.layer.shadowOffset = CGSizeMake(0, 0);
        buttonView.layer.shadowRadius = 3;
        buttonView.layer.shadowOpacity = 0.5;
        
    }
    
    class func round(buttonView: UIView) -> Void {
        buttonView.layer.cornerRadius = buttonView.frame.width/2
        buttonView.layer.masksToBounds = false;
        buttonView.layer.shadowOffset = CGSizeMake(0, 0);
        buttonView.layer.shadowRadius = 3;
        buttonView.layer.shadowOpacity = 0.5;
        
    }
    
    class func buttonEnlarger(buttonView: UIView, scale: Float) -> Void {
        buttonView.transform = CGAffineTransformMakeScale(CGFloat(scale), CGFloat(scale));
    }
    
}
