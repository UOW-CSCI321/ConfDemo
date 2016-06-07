//
//  EventDetailTableViewController.swift
//  ConfPlus
//
//  Created by CY Lim on 19/03/2016.
//  Copyright © 2016 Conf+. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class EventDetailTableViewController: UITableViewController, MKMapViewDelegate {
	@IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet var posterImageView: UIImageView!
	@IBOutlet weak var eventNameLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
    @IBOutlet var descriptionTextView: UITextView!
	@IBOutlet weak var locationMapView: MKMapView!
    @IBOutlet var addressTextView: UITextView!
    let regionRadius: CLLocationDistance = 1000
    let desc = "test description"
    let address = "test address"
    var event:Event!
    var venue:Venue?
	
    @IBOutlet var eventDetailsTableView: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		print(event.event_id)
		setData()
    }
	
	override func viewWillAppear(animated: Bool) {
		setText()
		APIManager().getVenue(event){ result in
			if result {
				self.setData()
				self.tableView.reloadData()
			}
		}

	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "goToTicketDetails" {
			let vc = segue.destinationViewController as! TicketDetailsViewController
			vc.event = event
		}
	}
	
	func setText(){
		navigationItem.title = "Event Details".localized()
		
		purchaseButton.setTitle("Purchase Tickets".localized(), forState: .Normal)
	}
	
	func setData(){
		posterImageView.image = event.getImage()
		eventNameLabel.text = event.name
		dateLabel.text = "\(event.getFromDateAsString()) - \(event.getToDateAsString())"
		descriptionTextView.text = event.desc
		
		venue = ModelHandler().getVenueByEvent(event)
		if venue != nil {
			setVenueData()
		}
	}
    
    func setVenueData() {
		
        let lat = Double(venue!.latitude!)
        let long = Double(venue!.longitude!)
        
        let location = CLLocationCoordinate2DMake(lat!, long!)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = venue!.name //"title"
        //annotation.subtitle = "subtitle"
        locationMapView.addAnnotation(annotation)
        
        var address:String?
        address = "\(venue!.street!), \(venue!.city!), \(venue!.state!), \(venue!.country!)"
        //address
        addressTextView.text = address
        
        //var span = MKCoordinateSpanMake(spanValue, spanValue)
        
        
        //let initialLocation = CLLocation(latitude: lat, longitude: long)
        centerMapOnLocation(location)


    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, regionRadius * 2.0, regionRadius * 2.0)
        locationMapView.setRegion(coordinateRegion, animated: true)
    }
    
    // called for each annotation
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView // if avaliable reuse annotation view

            {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // use annotation view
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                //view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
            }
            return view
        }
        return nil
    }
}
