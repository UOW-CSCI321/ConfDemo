//
//  Venue.swift
//  
//
//  Created by Matthew Boroczky on 27/05/2016.
//
//

import Foundation
import CoreData
import UIKit


class Venue: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    func getImage() -> UIImage? {
        if (map != "" || map != nil) {
            if let dataString = map {
                if let data = dataString.componentsSeparatedByString(",").last {
                    if let decodedData = NSData(base64EncodedString: data, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters) {
                        
                        //self.poster = decodedData
                        //ModelHandler().performUpdate()
                        
                        return UIImage(data: decodedData)!
                    }
                }
            }
        }
        return UIImage(named: "matt")!
    }
}
