//
//  MapViewController.swift
//  confDemo
//
//  Created by CY Lim on 15/03/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import Foundation
import UIKit

class EventLocationViewController:UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var scrollview: UIScrollView!
    var mapImageView =  UIImageView()
    var event:Event!
    var venue:Venue?
    
	@IBAction func dismissLocationView(sender: AnyObject) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(event.venue_id)
        self.scrollview.delegate = self
        print(scrollview.frame.size.height)
        //let a = CGRectMake(0, 0, self.scrollview.frame.size.width, self.scrollview.frame.size.height)
        mapImageView.frame = CGRectMake(0, 0, self.scrollview.frame.size.width, self.scrollview.frame.size.height)
        mapImageView.userInteractionEnabled = true
        mapImageView.contentMode = UIViewContentMode.Center
        
    }
    
    override func viewWillAppear(animated: Bool) {
        getVenue() //gets venue from api
        
    }
    
    func getVenue()
    {
        APIManager().getVenue(self.event){ result in
            if let eventsVenue = ModelHandler().getVenueByEvent(self.event)
            {
                APIManager().getMapForVenue(eventsVenue) { result in
                    self.venue = ModelHandler().getVenueByEvent(self.event)
                    //successfully have the venue map
                    //print(self.venue?.map)
                    
                    
                    //self.mapImageView.image = self.venue?.getImage()
                    let img = self.venue?.getImage()
                    self.mapImageView.image = img
                    
                    self.mapImageView.frame = CGRectMake(0, 0, (img?.size.width)!, (img?.size.height)!)
                    self.scrollview.addSubview(self.mapImageView)
                    self.scrollview.contentSize = (img?.size)!
                    
                    let scrollViewFrame = self.scrollview.frame
                    let sWidth = scrollViewFrame.size.width / self.scrollview.contentSize.width
                    let sHeight = scrollViewFrame.size.height / self.scrollview.contentSize.height
                    let minScale = min(sHeight, sWidth)
                    
                    self.scrollview.minimumZoomScale = minScale
                    self.scrollview.maximumZoomScale = 1
                    self.scrollview.zoomScale = minScale
                    self.centerScrollViewContent()
                }
            }
        }
    }
    
    func centerScrollViewContent() {
        let boundsSize = scrollview.bounds.size
        var contentsFrame = mapImageView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width)/2
        }else {
            contentsFrame.origin.x = 0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height)/2
        }else {
            contentsFrame.origin.y = 0
        }
        
        mapImageView.frame = contentsFrame
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        centerScrollViewContent()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return mapImageView
    }
    
}