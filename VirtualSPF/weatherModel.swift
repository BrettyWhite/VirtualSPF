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
var delegate: WeatherDelegate?

protocol WeatherDelegate: class {
    func didChangeProxyState(_ newState: NetworkState, data: JSON)
}

class WeatherModel {
    /// Model function for getting the weather data
    ///
    /// - Parameter coordinates: Send over CLLocation obtained from device's GPS
    class func getWeather(_ coordinates: CLLocation) {

        let data: JSON = JSON.null
        delegate?.didChangeProxyState(NetworkState.searching, data: data)
        let coord = coordinates.coordinate
        // If this line is erroring out, see sampleEnvVars.swift to see what you need to do
        let apiKey = VSPFProtectedConstants.DarkSkyKey
        let weatherEndpoint: String = "https://api.darksky.net/forecast/\(apiKey)/\(coord.latitude),\(coord.longitude)?exclude=minutely,flags,daily"

        Alamofire.request(weatherEndpoint, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { response in
            if ((response.error) != nil) {
                delegate?.didChangeProxyState(NetworkState.error, data: JSON.null)
                return
            }
            if let data = response.data {
                let jsondata = JSON(data:data as Data)
                let weather = jsondata
                delegate?.didChangeProxyState(NetworkState.finished, data: weather)
            }
        }
    }
}
