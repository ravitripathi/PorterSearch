//
//  ViewController.swift
//  Porter-Assignment
//
//  Created by Shameek Sarkar on 13/11/19.
//  Copyright © 2019 Shameek Sarkar. All rights reserved.
//

import UIKit
import MapKit

class HomeController: UIViewController {
    //  @IBOutlet weak var pickupButton: UIButton!
    //  @IBOutlet weak var dropButton: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    //  @IBOutlet weak var bookButton: UIButton!
    /* Service */
    private var porterService: PorterService = HttpPorterService()
    
    let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    private func initViews() {
        self.mapView.showsUserLocation = true
        let button = MKUserTrackingButton(mapView: self.mapView)
        button.backgroundColor = UIColor.white
        self.mapView.addSubview(button)
        button.anchor(top: nil, left: nil, bottom: self.mapView.bottomAnchor, right: self.mapView.rightAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 16.0, paddingRight: 16.0, width: 32.0, height: 32.0)
    }
    
    @objc private func didTapPickupLocation() {
        performSegue(withIdentifier: Segues.SearchLocation.rawValue, sender: self)
    }
    
    @objc private func didTapDropLocation() {
        performSegue(withIdentifier: Segues.SearchLocation.rawValue, sender: self)
    }
    
    @objc private func didTapBook() {
        
    }
}
