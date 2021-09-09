//
//  Address.swift
//  Suffolk Sales
//
//  Created by Charlie Brush on 7/2/21.
//

import Foundation

struct Address: Codable, Hashable {
    let street: String
    let town: String
    let zip: String
    
    init(street: String, town: String, zip: String) {
        self.street = street
        self.town = town
        self.zip = zip
    }
//
//    func getPlacemark() -> CLPlacemark {
//
//    }
}




