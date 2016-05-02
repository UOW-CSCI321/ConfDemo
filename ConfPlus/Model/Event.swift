//
//  Event.swift
//  
//
//  Created by Matthew Boroczky on 1/05/2016.
//
//

import Foundation
import CoreData
import UIKit


class Event: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
        func imageTypeIsValid() -> String
        {
            var s1:String = self.poster_url!
            s1.removeRange(s1.startIndex..<s1.startIndex.advancedBy(11))
            //.startIndex.advancedBy(10)
            //print("imgtype: \(s1)")
    
            let delim : Character = ";"
            let index = s1.lowercaseString.characters.indexOf(delim)
            //print("index: \(index)")
            let imgType = s1.substringToIndex(index!)
            //print("imgtype \(imgType)")
    
            if imgType == "png" || imgType == "PNG" || imgType == "jpeg" || imgType == "JPEG" || imgType == "gif" || imgType == "GIF"
            {
                //print("valid type")
                return imgType
            }
            return "invalid"
        }
    
    func getImage() -> UIImage
    {
        var picString:String = self.poster_url!
        //print(picString)
        let imgtype = self.imageTypeIsValid() //imageTypeIsValid(picString)
        if(imgtype == "invalid"){
            print("error image from server is not a valid type")
            //return nil
        }else{
            
            let img = "data:image/\(imgtype);base64,"
            if let range = picString.rangeOfString(img, options: .AnchoredSearch)  {
                picString.removeRange(range)
            }
            
            if let decodedData = NSData(base64EncodedString: picString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters) {
                //print("decoded data: \(decodedData)")
                
                
                if let decodedimage = UIImage(data: decodedData, scale: 1.0){
                    //print(decodedimage)
                    //cell.eventImage.image = decodedimage
                    return decodedimage
                }
            }
        }
        let a = UIImage() //dummy
        return a
    }


}
