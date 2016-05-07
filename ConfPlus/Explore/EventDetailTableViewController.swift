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
	@IBOutlet weak var dateLabel: UITableViewCell!
    @IBOutlet var descriptionTextView: UITextView!
	@IBOutlet weak var locationMapView: MKMapView!
    @IBOutlet var addressTextView: UITextView!
    let regionRadius: CLLocationDistance = 1000
    let desc = "test description"
    let address = "test address"
    var selectedEvent:Event!
    var aVenue:Venue!
    var venues:[Venue] = []

    
    
    
    @IBOutlet var eventDetailsTableView: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        data_request()
		
		navigationController?.hidesBarsOnSwipe = true
        
        //aVenue = ModelHandler().getVenueData(selectedEvent.event_id!)
        venues = ModelHandler().getVenueData()
//        for i in 0...venues.count{
//            if selectedEvent.venue ==
//        }
        //addNewVenue - the same as addNewEvent
        //getVenueData - i think we actually return an array of event then traverse until we find the event we want and then say aevent.venue
        //alternative would be to not write getVenueData function and just say selectedEvent.venue
    }
    
    func setData()
    {
        //let imageName:String = "blithe.jpg"
        //let image = UIImage(named: imageName)
        posterImageView.image = selectedEvent.getImage()
        
        let lat = Double(aVenue.latitude!)
        let long = Double(aVenue.longitude!)
        
        let location = CLLocationCoordinate2DMake(lat!, long!)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = aVenue.name //"title"
        //annotation.subtitle = "subtitle"
        locationMapView.addAnnotation(annotation)
        
        var address:String?
        address = "\(aVenue.street!), \(aVenue.city!), \(aVenue.state!), \(aVenue.country!)"
        //address
        addressTextView.text = address
        
        //var span = MKCoordinateSpanMake(spanValue, spanValue)
        
        
        //let initialLocation = CLLocation(latitude: lat, longitude: long)
        centerMapOnLocation(location)


    }
    
    func data_request()
    {
        //coredata
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        let eventEntity = NSEntityDescription.entityForName("Venue", inManagedObjectContext: context)
        let eventid:String = (selectedEvent.event_id?.stringValue)!
        let defaults = NSUserDefaults.standardUserDefaults()
        let api_key:String = defaults.stringForKey("api_key")!
        let app_secret:String = defaults.stringForKey("app_secret")!
        
        //post request
        let paramaters = [
            "method" : "getVenue",
            "venue_id" : eventid,
            "api_key" : api_key,
            "app_secret" : app_secret
        ] //at the moment the api call need event id
        
        if let serverAdd = defaults.stringForKey("server")
        {
            Alamofire.request(.POST, serverAdd, parameters: paramaters).responseJSON {
                response in switch response.result
                {
                case .Success:
                    if let value = response.result.value
                    {
                        let json = JSON(value)
                        if(json["success"].stringValue == "false")
                        {
                            print("ERROR: message: \(json["message"].stringValue)");
                        }else
                        {
                            if json["data"].count > 1
                            {
                                print("error should have only received one venue")
                            }else{
                                self.aVenue = NSEntityDescription.insertNewObjectForEntityForName("Venue", inManagedObjectContext: context) as! Venue
                                self.aVenue.venue_id = json["data"][0]["venue_id"].intValue
                                self.aVenue.name = json["data"][0]["name"].stringValue
                                self.aVenue.type = json["data"][0]["type"].stringValue
                                self.aVenue.street = json["data"][0]["street"].stringValue
                                self.aVenue.city = json["data"][0]["city"].stringValue
                                self.aVenue.state = json["data"][0]["state"].stringValue
                                self.aVenue.country = json["data"][0]["country"].stringValue
                                self.aVenue.latitude = json["data"][0]["latitude"].stringValue
                                self.aVenue.longitude = json["data"][0]["longitude"].stringValue
                                //self.aVenue.mutableSetValueForKey("venue").addObject(self.aVenue)
                               // self.selectedEvent.venue = self.aVenue //not sure if this will actually change the data the database because the events array is in exploreViewController but this is an event object which we will call save on so it should save
                            }
                            //clear current data in the database
                            
                            //save to database
                            do {
                                try context.save()
                            } catch {
                                fatalError("Failure to save context in EventDetailsTableViewController: \(error)")
                            }
                            
                            self.setData()

                        }
                                                //reload tableview - make sure loading from database not loading from server as we are currently
                        self.eventDetailsTableView.reloadData()
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
