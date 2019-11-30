//
//  PricingService.swift
//  Porter-Assignment
//
//  Created by Shameek Sarkar on 13/11/19.
//  Copyright © 2019 Shameek Sarkar. All rights reserved.
//

import Foundation

protocol PorterService {
  func fetchServiceable(completion: @escaping (ServiceableResponse) -> Void)
  func fetchPrice(location: Location, completion: @escaping (PricingResponse) -> Void)
  func fetchEta(location: Location, completion: @escaping (EtaResponse) -> Void)
}

struct ServiceableResponse: Codable {
  let serviceable: Bool
}

struct PricingResponse: Codable {
  let cost: Int
}

struct EtaResponse: Codable {
  let eta: Int
}
