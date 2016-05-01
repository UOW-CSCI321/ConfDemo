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
import Alamofire
import SwiftyJSON
import CoreData

class EventDetailTableViewController: UITableViewController, MKMapViewDelegate {
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var descriptionTextView: UITextView!
	@IBOutlet weak var locationMapView: MKMapView!
    @IBOutlet var addressTextView: UITextView!
    let regionRadius: CLLocationDistance = 1000
    let desc = "test description"
    let address = "test address"
    var selectedEvent:Event!

    
    
    
	
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //var spanValue = 0.2
        
        //poster
        let imageName:String = "blithe.jpg"
        let image = UIImage(named: imageName)
        posterImageView.image = image
        
        
        //decsription
        //descriptionTextView.text = desc
        descriptionTextView.text = selectedEvent.desc
        
        //map
        //locationMapView.delegate = self
        let lat = 21.282778
        let long = -157.829444
        
        let location = CLLocationCoordinate2DMake(lat, long)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "title"
        annotation.subtitle = "subtitle"
        locationMapView.addAnnotation(annotation)
        
        //address
        addressTextView.text = address
        
        //var span = MKCoordinateSpanMake(spanValue, spanValue)
        
        
        //let initialLocation = CLLocation(latitude: lat, longitude: long)
        centerMapOnLocation(location)
        
        /*let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        annotation.title = "title"
        annotation.subtitle = "subtitle"
        locationMapView.addAnnotation(annotation)*/
    }
    
    func data_request()
    {
        //coredata
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        let eventEntity = NSEntityDescription.entityForName("Event", inManagedObjectContext: context)
        
        //post request
        let paramaters = [
            "method" : "getEventsByTag",
            "tag_name" : "testTag"
        ] //at the moment the api call need event id
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let serverAdd = defaults.stringForKey("server")
        {
            Alamofire.request(.POST, serverAdd, parameters: paramaters).responseJSON {
                response in switch response.result
                {
                case .Success:
                    if let value = response.result.value
                    {
                        let json = JSON(value)
                        
                        for i in 0 ..< json["data"].count
                        {
                            let aevent = NSEntityDescription.insertNewObjectForEntityForName("Event", inManagedObjectContext: context) as! Event
                            aevent.event_id = json["data"][i]["event_id"].intValue
                            //print("id: \(aevent.event_id)")
                            aevent.name = json["data"][i]["name"].stringValue
                            //print("name: \(aevent.name)")
                            aevent.type = json["data"][i]["type"].stringValue
                            aevent.from_date = self.serverStringToDate(json["data"][i]["from_date"].stringValue)
                            //print("from date:\(aevent.from_date)")
                            aevent.to_date = self.serverStringToDate(json["data"][i]["to_date"].stringValue)
                            //print("to date:\(aevent.to_date)")
                            //aevent.venueid
                            aevent.desc = json["data"][i]["description"].stringValue
                            //print("desc: \(aevent.desc)")
                            //url
                            aevent.poster_url = json["data"][i]["poster_url"].stringValue
                            print("poster: \(aevent.poster_url)")
                            //aevent.tagname
                            
                            
                            self.eventArray.append(aevent);
                            
                        }
                        //clear current data in the database
                        
                        //save to database
                        do {
                            try context.save()
                        } catch {
                            fatalError("Failure to save context in ExploreViewController: \(error)")
                        }
                        
                        //reload tableview - make sure loading from database not loading from server as we are currently
                        self.EventsTableView.reloadData()
                    }
                case .Failure(let error):
                    print(error)
                    //handle if there is no internet connection by alerting the user
                    
                }
                
            }
            
        }else {
            print("server not set in LoginViewController")
        }
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
