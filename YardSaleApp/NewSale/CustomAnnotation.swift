//
//  CustomAnnotation.swift
//  Suffolk Sales
//
//  Created by Charlie Brush on 6/21/21.
//

import UIKit
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    var title: String?
    
    var subtitle: String?
    
    var sale: Sale!
    
    init(sale: Sale, coord: CLLocationCoordinate2D) {
        self.title = sale.address.street
        self.subtitle = sale.address.town
        self.coordinate = coord
        self.sale = sale
    }
}
