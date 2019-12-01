//
//  ServiceManager.swift
//  Porter-Assignment
//
//  Created by Ravi Tripathi on 02/12/19.
//  Copyright © 2019 Shameek Sarkar. All rights reserved.
//

import Foundation

class ServiceManager {
    static let places: PlacesService = MapKitPlacesService()
    static let porter: PorterService = HttpPorterService()
    //Singletion
    private init() {}
}
