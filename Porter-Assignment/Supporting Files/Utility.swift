//
//  Utility.swift
//  Porter-Assignment
//
//  Created by Ravi Tripathi on 30/11/19.
//  Copyright © 2019 Shameek Sarkar. All rights reserved.
//

import UIKit
import MapKit

enum SearchType {
    case from
    case to
    
    func getTitle() -> String {
        switch self {
        case .from:
            return "Enter Pickup Location"
        case .to:
            return "Enter Drop Location"
        }
    }
}

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

extension UIView {
    func anchor(top : NSLayoutYAxisAnchor?, left : NSLayoutXAxisAnchor?, bottom : NSLayoutYAxisAnchor?,right : NSLayoutXAxisAnchor?,paddingTop : CGFloat,paddingLeft : CGFloat,paddingBottom : CGFloat, paddingRight : CGFloat,width : CGFloat,height : CGFloat){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top{
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let left = left{
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let right = right{
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if(width != 0){
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if(height != 0){
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}


extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

extension CLLocationCoordinate2D: Equatable {}

public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return (lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude)
}
