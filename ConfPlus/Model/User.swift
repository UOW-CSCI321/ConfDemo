//
//  User.swift
//  
//
//  Created by Matthew Boroczky on 26/05/2016.
//
//

import Foundation
import CoreData
import UIKit


class User: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    func getImage() -> UIImage {
        if (profile_pic_url != "" || profile_pic_url != nil) {
            if let dataString = profile_pic_url {
                if let data = dataString.componentsSeparatedByString(",").last {
                    if let decodedData = NSData(base64EncodedString: data, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters) {
                        
                        self.profile_pic = decodedData
                        ModelHandler().performUpdate()
                        
                        return UIImage(data: decodedData)!
                    }
                }
            }
        }
        return UIImage(named: "account")!
    }
}
