//
//  PlacesService.swift
//  Porter-Assignment
//
//  Created by Shameek Sarkar on 13/11/19.
//  Copyright © 2019 Shameek Sarkar. All rights reserved.
//

import Foundation

protocol PlacesService {
  func search(query: String?, completion: ([Place]) -> Void)
}
