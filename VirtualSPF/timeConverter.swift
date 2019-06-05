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
        let time = getHourAbbreviateion(timeNum: String(strDate.suffix(6)))
        let dateCut = getBetterData(date: String(strDate.prefix(5)))
        let timeString = "\(dateCut ?? "") @ \(time ?? "")"
        return timeString
    }

    class func getBetterData(date: String) -> String? {
        guard let month = getMonthAbbreviateion(month: String(date.prefix(2))) else { return nil }
        guard let day = getDayAbbreviateion(day: String(date.suffix(2))) else { return nil }
        return month + " " + day
    }

    class func getDayAbbreviateion(day: String) -> String? {
        switch day {
        case "01":
            return "1st"
        case "02":
            return "2nd"
        case "03":
            return "3rd"
        case "04":
            return "4th"
        case "05":
            return "5th"
        case "06":
            return "6th"
        case "07":
            return "7th"
        case "08":
            return "8th"
        case "09":
            return "9th"
        case "10":
            return "10th"
        case "11":
            return "11th"
        case "12":
            return "12th"
        case "13":
            return "13th"
        case "14":
            return "14th"
        case "15":
            return "15h"
        case "16":
            return "16th"
        case "17":
            return "17th"
        case "18":
            return "18th"
        case "19":
            return "19th"
        case "20":
            return "20th"
        case "21":
            return "21st"
        case "22":
            return "22nd"
        case "23":
            return "23rd"
        case "24":
            return "24th"
        case "25":
            return "25th"
        case "26":
            return "26th"
        case "27":
            return "27th"
        case "28":
            return "28th"
        case "29":
            return "29th"
        case "30":
            return "30th"
        case "31":
            return "31st"
        default:
            print("error")
        }
        return "error"
    }

   class func getMonthAbbreviateion(month: String) -> String? {
        switch month {
        case "01":
            return "Jan"
        case "02":
            return "Feb"
        case "03":
            return "Mar"
        case "04":
            return "Apr"
        case "05":
            return "May"
        case "06":
            return "Jun"
        case "07":
            return "Jul"
        case "08":
            return "Aug"
        case "09":
            return "Sep"
        case "10":
            return "Oct"
        case "11":
            return "Nov"
        case "12":
            return "Dec"
        default:
            print("error")
        }
        return "error"
    }

    class func getHourAbbreviateion(timeNum: String) -> String? {
        let time = timeNum[1 ..< 3]
        switch time {
        case "01":
            return "1 am"
        case "02":
            return "2 am"
        case "03":
            return "3 am"
        case "04":
            return "4 am"
        case "05":
            return "5 am"
        case "06":
            return "6 am"
        case "07":
            return "7 am"
        case "08":
            return "8 am"
        case "09":
            return "9 am"
        case "10":
            return "10 am"
        case "11":
            return "11 am"
        case "12":
            return "noon"
        case "13":
            return "1 pm"
        case "14":
            return "2 pm"
        case "15":
            return "3 pm"
        case "16":
            return "4 pm"
        case "17":
            return "5 pm"
        case "18":
            return "6 pm"
        case "19":
            return "7 pm"
        case "20":
            return "8 pm"
        case "21":
            return "9 pm"
        case "22":
            return "10 pm"
        case "23":
            return "11 pm"
        case "00":
            return "midnight"
        default:
            print("error")
        }
        return "error"
    }

}

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }

}
