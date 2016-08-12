//
//  ViewController.swift
//  VirtualSPF
//
//  Created by brettwmc on 7/26/15.
//  Copyright (c) 2015 brettwmc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import MBProgressHUD

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource{
    
    var locationManager: CLLocationManager!
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    var locationStatus : NSString = "Not Started"
    var weatherArray : JSON = [:]
    var cell : mainCell?
    
    //outlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var infoBtn: UIBarButtonItem?
    @IBOutlet weak var settingsBTN: UIButton?

    override func viewDidLoad() {
        
        super.viewDidLoad()

        // change color
        self.navigationController!.navigationBar.barTintColor = UIColor.yellowColor()
        
        // gather location data
        initLocationManager()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Networking

    func getWeather(zip : NSString){
        
        // Build URL with coords from zip
        let weatherEndpoint: String = "http://iaspub.epa.gov/enviro/efservice/getEnvirofactsUVHOURLY/ZIP/\(zip)/JSON"

        // Use alamofire and a GET request to get weather data from EPA.
        // Use SwiftyJSON to Handle JSON response
        
        Alamofire.request(.GET, weatherEndpoint, encoding: .JSON)
            .response { (req, res, json, error) in
                if  (error != nil)
                {
                    // stop the hud
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    // got an error in getting the data, need to handle it
                    print("error calling URL")
                    print(error)
                }
                else if let data: AnyObject = json
                {
                    // stop the hud
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    
                    let jsondata = JSON(data: data as! NSData)
                    
                    let weather = jsondata
                    
                    print(weather)
                    
                    // Call method to handle response
                    self.iterateResponse(weather)
                }
        }
    
    }
    
    // MARK: Response Handeling
    
    func iterateResponse(data : JSON){
        
        // set to global var we will use around the class
        weatherArray = data
        
        // call reload to tableview so it can now sort through the data
        tableView.reloadData()
        
    }
    
    // MARK: Table Stuff
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // return number of objects in weatherarray
        return self.weatherArray.count;
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // since we are using a prototype cell, we find it on the storyboard here, not in the register call in VDL
        cell = tableView.dequeueReusableCellWithIdentifier("mainCellID", forIndexPath: indexPath) as? mainCell
        
        // parse out individual items from each object to display in the cell
        let uvi = weatherArray[indexPath.row]["UV_VALUE"]
        let hour = weatherArray[indexPath.row]["DATE_TIME"]
        
        let cellTime: String = "\(hour)"
        let cellUVI: String = "\(uvi)"
        
        //print(cellTime)
        //print(cellUVI)
        
        // set info to outlets in the cell. dont forget to connect outlets in the storyboard
        //dispatch_async(dispatch_get_main_queue()) {
            self.cell!.selectionStyle = UITableViewCellSelectionStyle.None
            self.cell!.uviLabel.text = cellUVI
            self.cell!.timeLabel.text = cellTime
            //print(self.cell!.uviLabel.text)
        //}
        
        // we will now convert uvi to an int, and based on the value, change the cell's background color to 
        // denote the intensity of the UV light
        
        let uvint: Int? = Int(cellUVI)
        
        var strokeColor: UIColor
        strokeColor = UIColor(CGColor: UIColor(rgba: "#fff").CGColor)
        
        if (uvint >= 11) {
            strokeColor = UIColor(CGColor: UIColor(rgba: "#ff0000").CGColor)
        }else if (uvint >= 8){
            strokeColor = UIColor(CGColor: UIColor(rgba: "#ff9900").CGColor)
        }else if (uvint >= 6){
            strokeColor = UIColor(CGColor: UIColor(rgba: "#ffcc00").CGColor)
        }else if (uvint >= 3){
            strokeColor = UIColor(CGColor: UIColor(rgba: "#ffff66").CGColor)
        }else if (uvint >= 0){
            strokeColor = UIColor(CGColor: UIColor(rgba: "#1cd61c").CGColor)
        }

        // set cell bg color
        cell!.backgroundColor = strokeColor
        
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //println("You selected cell #\(indexPath.row)!")
        
    }
    
    // MARK: Location Stuff
    
    func initLocationManager() {
        
        // define some bool's
        seenError = false
        locationFixAchieved = false
        
        //set up locationManager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //check to see if the user has 1. allowed location access or 2. denied it.
        // if 1, we will request it via an alert, if 2, display an alert saying this wont work without permission
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            
            // if not determined, ask permission
            locationManager.requestWhenInUseAuthorization()
            
        }else if CLLocationManager.authorizationStatus() == .Denied{
            
            settingsBTN?.hidden = false
            
            // if denied, show alert
            let alertController = UIAlertController(
                title: "Location Access Disabled",
                message: "In order to get UV Index data for you, you need to enable location access, but for only when you use the app. We never access location when the app is not in use.",
                preferredStyle: .Alert)
            
            // cancel button
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            // link to app settings. this is important to have
            let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            alertController.addAction(openAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        // init GPS tracking
        locationManager.startUpdatingLocation()
        
        // start HUD
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Finding The Sun";
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // only do this if we have a location fix
        if (locationFixAchieved == false) {
            
            // hide enable location btn
            settingsBTN?.hidden = true
            
            locationFixAchieved = true
            
            // parse out location information from the CLLocationManager's response
            let locationArray = locations as NSArray
            let locationObj = locationArray.lastObject as! CLLocation
            let coord = locationObj.coordinate
            
            // with gps and glonass, iphones quickly aquire location and for a weather app, we dont need it to the 5 meter mark. we can stop immediately
            locationManager.stopUpdatingLocation()
            
            
            //create coords in a string to send to function to get weather data
            //var coords: String = "\(coord.latitude),\(coord.longitude)"
            
            //once we have location, init networking request to get weather data
            
            
            let geoCoder = CLGeocoder()
            
            let location = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
            
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                let placeArray = placemarks as [CLPlacemark]!
                
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placeArray?[0]
                
                // City
                if let city = placeMark.addressDictionary?["City"] as? NSString {
                    // set title
                    self.navigationItem.title = "UV Index - \(city)"
                }
                
                // Zip code
                if let zip = placeMark.addressDictionary?["ZIP"] as? NSString {
                    //call networking
                    self.getWeather(zip)
                }

                
            })

        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        // if it fails, stop trying to grab the location
        locationManager.stopUpdatingLocation()
        // stop the hud
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        print("Error with location manager")
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        // the reason this is important is if the class is already initialised and the user goes into settings
        // and changes the permission, this callback allows us to either 1. start gathering the location to show
        // data, or alert them that it will not work without permission
        
        switch CLLocationManager.authorizationStatus() {
            
        case .NotDetermined:
            
            // display the popup asking permission
            locationManager.requestAlwaysAuthorization()
        case .AuthorizedWhenInUse:
            
            // if authroized get location
            locationManager.startUpdatingLocation()
        case  .Restricted, .Denied:
            settingsBTN?.hidden = false
            //if denied, show alert why it wont work without permission
            let alertController = UIAlertController(
                title: "Location Access Disabled",
                message: "In order to get UV Index data for you, you need to enable location access, but for only when you use the app. We never access location when the app is not in use.",
                preferredStyle: .Alert)
            
            // cancel button
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            // link to app settings. this is important to have
            let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            alertController.addAction(openAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            // Switch / cases in swift require a "default" to fall back on, in this case, we will break
            default: break
        }
    }
    
    //MARK: other stuff
    
    @IBAction func openSettings(sender: UIButton) {
        let alertController = UIAlertController(
            title: "Location Access Disabled",
            message: "In order to get UV Index data for you, you need to enable location access, but for only when you use the app. We never access location when the app is not in use.",
            preferredStyle: .Alert)
        
        // cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // link to app settings. this is important to have
        let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
            if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        alertController.addAction(openAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //this function is a "catch all" for any segues from this class. we can catch specific segues by using their identifier on the storyboard
        if segue.identifier == "explainSegue" {
            
            // grab the index
            let row = self.tableView.indexPathForSelectedRow!.row
            
            // grab object at the index
            let uvi = weatherArray[row]["UV_VALUE"]
            //parse out the uvi for the object at that index
            let cellUVI: String = "\(uvi)"
            
            //define the controller that we are going to open with the segue to access its class vars
            let yourNextViewController = (segue.destinationViewController as! explainationView)
            
            //set the value we need for the next controller
            yourNextViewController.UVValue = cellUVI
        }
    }
}


