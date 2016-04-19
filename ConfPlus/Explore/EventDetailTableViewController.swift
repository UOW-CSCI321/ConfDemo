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

class EventDetailTableViewController: UITableViewController, MKMapViewDelegate {

	@IBOutlet weak var locationMapView: MKMapView!
    let regionRadius: CLLocationDistance = 1000
    let desc = "test description"
    let address = "test address"
    
	
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //var spanValue = 0.2
        
        //locationMapView.delegate = self
        let lat = 21.282778
        let long = -157.829444
        
        let location = CLLocationCoordinate2DMake(lat, long)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "title"
        annotation.subtitle = "subtitle"
        locationMapView.addAnnotation(annotation)
        
        //var span = MKCoordinateSpanMake(spanValue, spanValue)
        
        
        //let initialLocation = CLLocation(latitude: lat, longitude: long)
        centerMapOnLocation(location)
        
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
                //view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
            }
            return view
        }
        return nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        //return 0
//        return 4
//    }
//
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//                 //Configure the cell...
//        if indexPath == 0
//        {
//            //poster
//        } else if indexPath == 1
//        {
//            //description
//        }else if indexPath == 2
//        {
//            //poster
//        } else if indexPath == 3
//        {
//            //address
//        }else {
//            print("cell was not 0,1,2 or 3 but: \(indexPath)")
//        }
//
//        let cell = tableView.dequeueReusableCellWithIdentifier("posterCell", forIndexPath: indexPath)
//        
//        return cell
//    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
