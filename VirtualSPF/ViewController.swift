//
//  ViewController.swift
//  VirtualSPF
//
//  Created by brettywhite on 7/26/15.
//  Copyright (c) 2017 brettywhite. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import MBProgressHUD

class ViewController: BaseViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {

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

    class ViewController {
        init () {}
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        initLocationManager()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Networking
    fileprivate func getWeather(_ coordinates: CLLocation) {

        // Build URL with coords from zip

        let coord = coordinates.coordinate
        let apiKey = VSPFProtectedConstants.DarkSkyKey
        let weatherEndpoint: String = "https://api.darksky.net/forecast/\(apiKey)/\(coord.latitude),\(coord.longitude)?exclude=minutely,flags,daily"

        Alamofire.request(weatherEndpoint, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { response in

                if let data = response.data {

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
        weatherArray = data["hourly"]["data"]
        tableView.reloadData()
    }

    // MARK: Table Stuff
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherArray.count
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        cell = tableView.dequeueReusableCell(withIdentifier: "mainCellID", for: indexPath) as? MainCell

        let uvi = weatherArray[indexPath.row]["uvIndex"]
        let hour = weatherArray[indexPath.row]["time"]
        let cellTime: String = "\(hour)"
        let cellUVI: String = "\(uvi)"

        self.cell!.selectionStyle = UITableViewCellSelectionStyle.none
        self.cell!.uviLabel.text = cellUVI
        self.cell!.timeLabel.text = TimeConverter.convertTime(unixtime: cellTime)

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

        cell!.backgroundColor = strokeColor

        return cell!
    }

    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //println("You selected cell #\(indexPath.row)!")

    }
    // MARK: Location Stuff
    func initLocationManager() {

        seenError = false
        locationFixAchieved = false
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        if CLLocationManager.authorizationStatus() == .notDetermined {

            locationManager.requestWhenInUseAuthorization()

        } else if CLLocationManager.authorizationStatus() == .denied {

            settingsBTN?.isHidden = false

            let alertController = UIAlertController(
                title: "Location Access Disabled",
                message: "In order to get UV Index data for you, you need to enable location access, but for only when you use the app. We never access location when the app is not in use.",
                preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)

            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (_) in
                if let url = URL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(url)

                }
            }
            alertController.addAction(openAction)

            self.present(alertController, animated: true, completion: nil)
        }

        locationManager.startUpdatingLocation()

        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.labelText = "Finding The Sun"

    }

    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        // only do this if we have a location fix
        if locationFixAchieved == false {

            settingsBTN?.isHidden = true
            locationFixAchieved = true

            let locationArray = locations as NSArray
            let locationObj = locationArray.lastObject as! CLLocation
            let coord = locationObj.coordinate

            locationManager.stopUpdatingLocation()
            let location = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
            self.getWeather(location)
            }
    }

    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        locationManager.stopUpdatingLocation()
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        print("Error with location manager")

    }

    internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        switch CLLocationManager.authorizationStatus() {

        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .authorizedWhenInUse:
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

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

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
            let row = self.tableView.indexPathForSelectedRow!.row
            let uvi = weatherArray[row]["uvIndex"]
            let cellUVI: String = "\(uvi)"
            let explainationViewController = (segue.destination as! ExplainationView)
            explainationViewController.UVValue = cellUVI
        }
    }
}
