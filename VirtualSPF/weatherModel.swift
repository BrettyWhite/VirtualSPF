//
//  weatherModel.swift
//  VirtualSPF
//
//  Created by Bretty White on 10/2/17.
//  Copyright © 2017 Bretty. All rights reserved.
//

import CoreLocation
import UIKit

import Alamofire
import SwiftyJSON

enum NetworkState {
    case finished
    case searching
    case error
}
weak var delegate: WeatherDelegate!

protocol WeatherDelegate: class {
    func didChangeState(_ newState: NetworkState, data: JSON)
}

class WeatherModel {
    /// Model function for getting the weather data
    ///
    /// - Parameter coordinates: Send over CLLocation obtained from device's GPS
    class func getWeather(_ coordinates: CLLocation) {

        delegate?.didChangeState(NetworkState.searching, data: JSON.null)
        let coord = coordinates.coordinate
        // If this line is erroring out, see sampleEnvVars.swift to see what you need to do
        let apiKey = VSPFProtectedConstants.DarkSkyKey
        let weatherEndpoint: String = "https://api.darksky.net/forecast/\(apiKey)/\(coord.latitude),\(coord.longitude)?exclude=minutely,flags,daily,alerts"

        Alamofire.request(weatherEndpoint).responseJSON { response in

            if (response.error) != nil {
                delegate?.didChangeState(NetworkState.error, data: JSON.null)
                return
            }

            if let data = response.data {
                do {
                    let json = try JSON(data: data)
                    delegate?.didChangeState(NetworkState.finished, data: json)
                } catch {
                    print("Unexpected error: \(error).")
                }
            }
        }
    }
}
