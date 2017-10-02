//
//  timeConverter.swift
//  VirtualSPF
//
//  Created by Bretty White on 10/2/17.
//  Copyright © 2017 Brett Mcisaac. All rights reserved.
//

import Foundation

class TimeConverter {

    class func convertTime(unixtime: String) -> String? {
        let unixtimeDouble = Double(unixtime)
        let date = Date(timeIntervalSince1970: unixtimeDouble!)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "EST") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
}
