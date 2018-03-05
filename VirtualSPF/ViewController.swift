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

class ViewController: BaseViewController, WeatherDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    var locationManager: CLLocationManager!
    var seenError: Bool = false
    var locationFixAchieved: Bool = false
    var locationStatus: NSString = VSPFConstants.NotStarted as NSString
    var weatherArray: JSON = [:]
    var cell: MainCell?
    var state: NetworkState = .finished

    //outlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var infoBtn: UIBarButtonItem?
    @IBOutlet weak var settingsBTN: UIButton?

    class ViewController {
        init () {}
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        initLocationManager()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        strokeColor = Colors.White

        if uvint >= 11 {
            strokeColor = Colors.Red
        } else if uvint >= 8 {
            strokeColor = Colors.Orange
        } else if uvint >= 6 {
            strokeColor = Colors.Yellow
        } else if uvint >= 3 {
            strokeColor = Colors.LightYellow
        } else if uvint >= 0 {
            strokeColor = Colors.Green
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
                title: VSPFConstants.LocationDisabled,
                message: VSPFConstants.LocationMessage,
                preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: VSPFConstants.Cancel, style: .cancel, handler: nil)
            alertController.addAction(cancelAction)

            let openAction = UIAlertAction(title: VSPFConstants.OpenSettings, style: .default) { (_) in
                if let url = URL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            alertController.addAction(openAction)

            self.present(alertController, animated: true, completion: nil)
        }

        locationManager.startUpdatingLocation()

        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.labelText = VSPFConstants.FindingSun
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
            WeatherModel.getWeather(location)
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
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case  .restricted, .denied:
            settingsBTN?.isHidden = false
            //if denied, show alert why it wont work without permission
            let alertController = UIAlertController(
                title: VSPFConstants.LocationDisabled,
                message: VSPFConstants.LocationMessage,
                preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: VSPFConstants.Cancel, style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            let openAction = UIAlertAction(title: VSPFConstants.OpenSettings, style: .default) { (_) in
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
            title: VSPFConstants.LocationDisabled,
            message: VSPFConstants.LocationMessage,
            preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: VSPFConstants.Cancel, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        let openAction = UIAlertAction(title: VSPFConstants.OpenSettings, style: .default) { (_) in
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

    func displayHUD() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.labelText = VSPFConstants.FindingSun
    }

    func hideHUD() {
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
    }

    // MARK: - Delegate Functions
    func didChangeProxyState(_ newState: NetworkState, data: JSON) {
        state = newState

        switch newState {
        case .searching:
            displayHUD()
        case .finished:
            hideHUD()
            iterateResponse(data)
        case .error:
            hideHUD()
        }
    }
}
