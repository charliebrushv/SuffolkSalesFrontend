//
//  Type.swift
//  Suffolk Sales
//
//  Created by Charlie Brush on 7/2/21.
//

struct Type: Codable {
    var type: SaleType
    var isOn: Bool
    
    init(type: SaleType, isOn: Bool = false) {
        self.type = type
        self.isOn = isOn
    }
    
}

enum SaleType: String, Codable, CaseIterable {
    case yard = "Yard", tag = "Tag", garage = "Garage", estate = "Estate"
}
