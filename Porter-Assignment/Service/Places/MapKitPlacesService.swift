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
}
