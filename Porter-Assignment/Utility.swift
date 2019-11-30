//
//  Utility.swift
//  Porter-Assignment
//
//  Created by Ravi Tripathi on 30/11/19.
//  Copyright © 2019 Shameek Sarkar. All rights reserved.
//

import Foundation
import MapKit

class Utility {
    static func getPlace(fromMapItem mapItem: MKMapItem?) -> Place? {
        guard let mapItem = mapItem,
            let name = mapItem.name,
            let address = mapItem.placemark.title else {
            return nil
        }
        let lat = Double(mapItem.placemark.coordinate.latitude)
        let lng = Double(mapItem.placemark.coordinate.longitude)
        let location = Location(lat: lat, lng: lng)
        return Place(name: name, address: address, location: location)
    }
}
