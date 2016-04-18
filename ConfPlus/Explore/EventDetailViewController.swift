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

class EventDetailViewController: UIViewController, UITableViewDelegate, MKMapViewDelegate {

    @IBOutlet var tableview: UITableView!
	@IBOutlet weak var locationMapView: MKMapView!
    let regionRadius: CLLocationDistance = 1000
	
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //var spanValue = 0.2
        
        //locationMapView.delegate = self
        let lat:CLLocationDegrees = -34.406513
        let long:CLLocationDegrees = 150.882454
        /*let coordinate = CLLocationCoordinate2DMake(lat, long)
        
        let spanval:CLLocationDegrees = 0.01
        let span = MKCoordinateSpan(latitudeDelta: spanval, longitudeDelta: spanval)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        locationMapView.setRegion(region, animated: true)
        
        let annot = MKPointAnnotation()
        annot.title = "a"
        annot.subtitle = "b"
        annot.coordinate = coordinate;
        
        
        locationMapView.addAnnotation(annot)*/
        //let lat = 21.282778
       // let long = -157.829444
        
        let location = CLLocationCoordinate2DMake(lat, long)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "title"
        annotation.subtitle = "subtitle"
        locationMapView.addAnnotation(annotation)
        
        //var span = MKCoordinateSpanMake(spanValue, spanValue)
        
        
        //let initialLocation = CLLocation(latitude: lat, longitude: long)
        //centerMapOnLocation(location)
        
        /*let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        annotation.title = "title"
        annotation.subtitle = "subtitle"
        locationMapView.addAnnotation(annotation)*/
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
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
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
                //view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as UIView
            }
            return view
        }
        return nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}