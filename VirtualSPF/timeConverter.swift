//
//  timeConverter.swift
//  VirtualSPF
//
//  Created by Bretty White on 10/2/17.
//  Copyright © 2017 Bretty White. All rights reserved.
//

import Foundation

class TimeConverter {
    /// Converts time from Unix time to Human readable
    ///
    /// - Parameter unixtime: time in unix format
    /// - Returns: a human readable string
    class func convertTime(unixtime: String) -> String? {
        let unixtimeDouble = Double(unixtime)
        let date = Date(timeIntervalSince1970: unixtimeDouble!)
        let dateFormatter = DateFormatter()
        //Set time zone
        //TODO: make this based on local time
        dateFormatter.timeZone = TimeZone(abbreviation: "EST")
        dateFormatter.locale = NSLocale.current
        //Specify your format that you want
        dateFormatter.dateFormat = "MM-dd HH:mm"
        let strDate = dateFormatter.string(from: date)
        let time = strDate.suffix(6)
        let dateCut = strDate.prefix(5)
        let timeString = "Day: \(dateCut) @\(time)"
        return timeString
    }
}
