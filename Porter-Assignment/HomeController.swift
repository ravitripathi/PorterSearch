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
    
    @IBOutlet weak var pickUpLabel: UILabel!
    @IBOutlet weak var dropLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
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
        setupTapGestures()
    }
    
    private func setupTapGestures() {
        pickUpLabel.isUserInteractionEnabled = true
        pickUpLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapPickupLocation)))
        dropLabel.isUserInteractionEnabled = true
        dropLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapDropLocation)))
    }
    
    private func initViews() {
        self.mapView.showsUserLocation = true
        let button = MKUserTrackingButton(mapView: self.mapView)
        button.backgroundColor = UIColor.white
        self.mapView.addSubview(button)
        button.anchor(top: nil, left: nil, bottom: self.mapView.bottomAnchor, right: self.mapView.rightAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 16.0, paddingRight: 16.0, width: 32.0, height: 32.0)
    }
    
    @objc private func didTapPickupLocation() {
        performSegue(withIdentifier: Segues.SearchLocation.rawValue, sender: SearchType.from)
    }
    
    @objc private func didTapDropLocation() {
        performSegue(withIdentifier: Segues.SearchLocation.rawValue, sender: SearchType.to)
    }
    
    @objc private func didTapBook() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? SearchController, let searchType = sender as? SearchType else {
            return
        }
        vc.delegate = self
        vc.searchType = searchType
    }
}

extension HomeController: SearchControllerDelegate {
    
    func didSelect(location: MKMapItem, searchType: SearchType) {
        if searchType == .from {
            self.pickUpLabel.text = location.name
        } else {
            self.dropLabel.text = location.name
        }
    }
}
