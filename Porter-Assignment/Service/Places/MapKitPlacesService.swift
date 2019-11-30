//
//  MapKitPlacesService.swift
//  Porter-Assignment
//
//  Created by Shameek Sarkar on 13/11/19.
//  Copyright © 2019 Shameek Sarkar. All rights reserved.
//

import Foundation
import MapKit

class MapKitPlacesService: PlacesService {
    func search(query: String?, completion: @escaping ([MKMapItem]?) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            completion(response?.mapItems)
        }
    }
    
    func lookUpCurrent(location: CLLocation?, completionHandler: @escaping (CLPlacemark?)
        -> Void ) {
        if let lastLocation = location {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(lastLocation,
                                            completionHandler: { (placemarks, error) in
                                                if error == nil {
                                                    let firstLocation = placemarks?[0]
                                                    completionHandler(firstLocation)
                                                }
                                                else {
                                                    // An error occurred during geocoding.
                                                    completionHandler(nil)
                                                }
            })
        }
        else {
            // No location was available.
            completionHandler(nil)
        }
    }
}
