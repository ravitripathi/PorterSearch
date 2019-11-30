//
//  HttpPorterService.swift
//  Porter-Assignment
//
//  Created by Shameek Sarkar on 13/11/19.
//  Copyright © 2019 Shameek Sarkar. All rights reserved.
//

import Foundation
import Alamofire

class HttpPorterService: PorterService {
    let baseUrl = "https://assignment-mobileapi.porter.in"
    
    func fetchServiceable(completion: @escaping (ServiceableResponse) -> Void) {
        AF.request(baseUrl + "/users/serviceability", method: .get)
            .responseDecodable(of: ServiceableResponse.self) { response in
                response.value.map { completion($0) }
        }
    }
    
    //Assuming the location is destination location
    func fetchPrice(location: Location, completion: @escaping (PricingResponse) -> Void) {
        AF.request(baseUrl + "/vehicles/cost", method: .get, parameters: location, encoder: URLEncodedFormParameterEncoder.default)
            .responseDecodable(of: PricingResponse.self) { response in
                response.value.map { completion($0) }
        }
    }
    
    //Assuming the location is destination location
    func fetchEta(location: Location, completion: @escaping (EtaResponse) -> Void) {
        AF.request(baseUrl + "/vehicles/eta", method: .get, parameters: location, encoder: URLEncodedFormParameterEncoder.default)
            .responseDecodable(of: EtaResponse.self) { response in
                response.value.map { completion($0) }
        }
    }
}
