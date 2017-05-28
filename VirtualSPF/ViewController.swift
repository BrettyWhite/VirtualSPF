//
//  ViewController.swift
//  VirtualSPF
//
//  Created by brettywhite on 7/26/15.
//  Copyright (c) 2015 brettywhite. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import MBProgressHUD

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    var locationManager: CLLocationManager!
    var seenError: Bool = false
    var locationFixAchieved: Bool = false
    var locationStatus: NSString = "Not Started"
    var weatherArray: JSON = [:]
    var cell: MainCell?

    //outlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var infoBtn: UIBarButtonItem?
    @IBOutlet weak var settingsBTN: UIButton?

    override func viewDidLoad() {

        super.viewDidLoad()
        self.navigationController!.navigationBar.barTintColor = UIColor.yellow
        initLocationManager()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Networking
    fileprivate func getWeather(_ zip: NSString) {

        // Build URL with coords from zip
        let weatherEndpoint: String = "http://iaspub.epa.gov/enviro/efservice/getEnvirofactsUVHOURLY/ZIP/\(zip)/JSON"

        Alamofire.request(weatherEndpoint, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { response in

                if let data = response.data {

                    // stop the hud
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)

                    let jsondata = JSON(data:data as Data)
                    let weather = jsondata
                    self.iterateResponse(weather)
                } else {
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            }
        }
    }
    // MARK: Response Handeling

    fileprivate func iterateResponse(_ data: JSON) {
        // set to global var we will use around the class
        weatherArray = data

        // call reload to tableview so it can now sort through the data
        tableView.reloadData()
    }
    // MARK: Table Stuff
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        // return number of objects in weatherarray
        return self.weatherArray.count

    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // since we are using a prototype cell, we find it on the storyboard here, not in the register call in VDL
        cell = tableView.dequeueReusableCell(withIdentifier: "mainCellID", for: indexPath) as? MainCell

        // parse out individual items from each object to display in the cell
        let uvi = weatherArray[indexPath.row]["UV_VALUE"]
        let hour = weatherArray[indexPath.row]["DATE_TIME"]
        let cellTime: String = "\(hour)"
        let cellUVI: String = "\(uvi)"

        self.cell!.selectionStyle = UITableViewCellSelectionStyle.none
        self.cell!.uviLabel.text = cellUVI
        self.cell!.timeLabel.text = cellTime

        let uvint: Int = Int(cellUVI)!

        var strokeColor: UIColor
        strokeColor = UIColor(cgColor: UIColor(rgba: "#fff").cgColor)

        if uvint >= 11 {
            strokeColor = UIColor(cgColor: UIColor(rgba: "#ff0000").cgColor)
        } else if uvint >= 8 {
            strokeColor = UIColor(cgColor: UIColor(rgba: "#ff9900").cgColor)
        } else if uvint >= 6 {
            strokeColor = UIColor(cgColor: UIColor(rgba: "#ffcc00").cgColor)
        } else if uvint >= 3 {
            strokeColor = UIColor(cgColor: UIColor(rgba: "#ffff66").cgColor)
        } else if uvint >= 0 {
            strokeColor = UIColor(cgColor: UIColor(rgba: "#1cd61c").cgColor)
        }

        // set cell bg color
        cell!.backgroundColor = strokeColor

        return cell!
    }

    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //println("You selected cell #\(indexPath.row)!")

    }
    // MARK: Location Stuff

    fileprivate func initLocationManager() {

        seenError = false
        locationFixAchieved = false
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        if CLLocationManager.authorizationStatus() == .notDetermined {
            // if not determined, ask permission
            locationManager.requestWhenInUseAuthorization()

        } else if CLLocationManager.authorizationStatus() == .denied {

            settingsBTN?.isHidden = false

            // if denied, show alert
            let alertController = UIAlertController(
                title: "Location Access Disabled",
                message: "In order to get UV Index data for you, you need to enable location access, but for only when you use the app. We never access location when the app is not in use.",
                preferredStyle: .alert)

            // cancel button
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)

            // link to app settings. this is important to have
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (_) in
                if let url = URL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(url)

                }
            }
            alertController.addAction(openAction)

            self.present(alertController, animated: true, completion: nil)
        }

        // init GPS tracking
        locationManager.startUpdatingLocation()

        // start HUD
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.labelText = "Finding The Sun"

    }

    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        // only do this if we have a location fix
        if locationFixAchieved == false {

            // hide enable location btn
            settingsBTN?.isHidden = true

            locationFixAchieved = true

            // parse out location information from the CLLocationManager's response
            let locationArray = locations as NSArray
            let locationObj = locationArray.lastObject as! CLLocation
            let coord = locationObj.coordinate
            // with gps and glonass, iphones quickly aquire location and for a weather app, we dont need it to the 5 meter mark. we can stop immediately
            locationManager.stopUpdatingLocation()

            let geoCoder = CLGeocoder()

            let location = CLLocation(latitude: coord.latitude, longitude: coord.longitude)

            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, _) -> Void in
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

    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        // if it fails, stop trying to grab the location
        locationManager.stopUpdatingLocation()
        // stop the hud
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        print("Error with location manager")

    }

    internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        switch CLLocationManager.authorizationStatus() {

        case .notDetermined:
            // display the popup asking permission
            locationManager.requestAlwaysAuthorization()
        case .authorizedWhenInUse:
            // if authroized get location
            locationManager.startUpdatingLocation()
        case  .restricted, .denied:
            settingsBTN?.isHidden = false
            //if denied, show alert why it wont work without permission
            let alertController = UIAlertController(
                title: "Location Access Disabled",
                message: "In order to get UV Index data for you, you need to enable location access, but for only when you use the app. We never access location when the app is not in use.",
                preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            // link to app settings. this is important to have
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (_) in
                if let url = URL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            alertController.addAction(openAction)

            self.present(alertController, animated: true, completion: nil)

            default: break
        }
    }

    // MARK: other stuff

    @IBAction func openSettings(_ sender: UIButton) {
        let alertController = UIAlertController(
            title: "Location Access Disabled",
            message: "In order to get UV Index data for you, you need to enable location access, but for only when you use the app. We never access location when the app is not in use.",
            preferredStyle: .alert)

        // cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        // link to app settings. this is important to have
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (_) in
            if let url = URL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
        alertController.addAction(openAction)
        self.present(alertController, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "explainSegue" {

            // grab the index
            let row = self.tableView.indexPathForSelectedRow!.row

            let uvi = weatherArray[row]["UV_VALUE"]
            //parse out the uvi for the object at that index
            let cellUVI: String = "\(uvi)"

            let yourNextViewController = (segue.destination as! ExplainationView)

            yourNextViewController.UVValue = cellUVI
        }
    }
}
