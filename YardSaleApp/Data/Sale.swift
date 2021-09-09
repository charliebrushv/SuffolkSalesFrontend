//
//  Sale.swift
//  YardSaleApp
//
//  Created by Charlie Brush on 6/12/21.
//

import Foundation
import MapKit

struct SalesDataResponse: Codable {
    let success: Bool
    let data: [SaleDataResponse]
}

struct SingleSaleDataResponse: Codable {
    let success: Bool
    let data: SaleDataResponse
}

struct SaleDataResponse: Codable {
    let id: Int
    let desc: String
    let type: String
    let lat: CLLocationDegrees?
    let long: CLLocationDegrees?
    let date: String
    let startTime: String
    let endTime: String
    let street: String
    let town: String
    let zip: String
}

struct Sale: Codable, Hashable {
    static func == (lhs: Sale, rhs: Sale) -> Bool {
        return lhs.desc==rhs.desc && lhs.dateRange==rhs.dateRange && lhs.type==rhs.type && lhs.address==rhs.address && lhs.lat==rhs.lat && lhs.long==rhs.long
    }
    
    var id: Int?
    var desc: String
    var dateRange: DateRange
    var type: SaleType
    var address: Address
    var lat: CLLocationDegrees?
    var long: CLLocationDegrees?
    
    init(desc: String, dateRange: DateRange, type: SaleType, address: Address) {
        self.desc = desc
        self.dateRange = dateRange
        self.type = type
        self.address = address
    }
    
    init(dataResponse: SaleDataResponse) {
        self.id = dataResponse.id
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.desc = dataResponse.desc
        self.type = SaleType(rawValue: dataResponse.type)!
        self.lat = dataResponse.lat
        self.long = dataResponse.long
        self.dateRange = DateRange(date: formatter.date(from: dataResponse.date)!, startTime: formatter.date(from: dataResponse.startTime)!, endTime: formatter.date(from: dataResponse.endTime)!)
        self.address = Address(street: dataResponse.street, town: dataResponse.town, zip: dataResponse.zip)
    }
    
    func getPlacemark() -> MKPlacemark? {
        if self.lat != nil && self.long != nil {
            let coord = CLLocationCoordinate2D(latitude: self.lat!, longitude: self.long!)
            return MKPlacemark(coordinate: coord) }
        else { return nil }
    }
    
    mutating func setCoord(place: CLPlacemark) {
        self.lat = place.location?.coordinate.latitude
        self.long = place.location?.coordinate.longitude
    }
    
//    func getCoord() -> CLLocationCoordinate2D {
//
//    }
}


