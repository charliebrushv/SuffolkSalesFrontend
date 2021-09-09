//
//  DateRange.swift
//  Suffolk Sales
//
//  Created by Charlie Brush on 7/2/21.
//

import Foundation
import MapKit

struct DateRange: Codable, Hashable {
    let date: Date
    let startTime: Date
    let endTime: Date

//    var startDate: Date
//    var endDate: Date
    static let formatter = DateFormatter()

//    init(startDate: Date, endDate: Date) {
//        self.startDate = startDate
//        self.endDate = endDate
//    }
    
    init(date: Date, startTime: Date, endTime: Date) {
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
    }
    
    func getWeekday() -> String {
        DateRange.formatter.dateFormat = "EEEE"
        return DateRange.formatter.string(from: date)
    }
    
    func getShortWeekday() -> String {
        DateRange.formatter.dateFormat = "EEE"
        return DateRange.formatter.string(from: date)
    }
    
    func getDate() -> String {
        DateRange.formatter.dateFormat = "M/dd"
        return DateRange.formatter.string(from: date)
    }
    
    func getStartTime() -> String {
        DateRange.formatter.dateFormat = "h:mm"
        return DateRange.formatter.string(from: startTime)
    }
    
    func getEndTime() -> String {
        DateRange.formatter.dateFormat = "h:mm"
        return DateRange.formatter.string(from: endTime)
    }
}
