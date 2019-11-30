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
    let group = DispatchGroup()
    var fromPin: MKAnnotation?
    var toPin: MKAnnotation? {
        didSet(value) {
            guard let coordinate = value?.coordinate else {
                return
            }
            self.fetchPricingAndEta(forLocation: coordinate)
        }
    }
    var pricing: String = ""
    var eta: String = ""
    
    /* Service */
    private var porterService: PorterService = HttpPorterService()
    private var placesService = MapKitPlacesService()
    
    let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
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
        button.layer.backgroundColor = UIColor(white: 1, alpha: 0.8).cgColor
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
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
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.placemark.coordinate
        
        if searchType == .from {
            self.pickUpLabel.text = location.name
            if let fromPin = self.fromPin {
                self.mapView.removeAnnotation(fromPin)
            }
            self.fromPin = annotation
        } else {
            self.dropLabel.text = location.name
            if let toPin = self.toPin {
                self.mapView.removeAnnotation(toPin)
            }
            self.toPin = annotation
        }
        
        self.mapView.addAnnotation(annotation)
        self.mapView.setCenter(location.placemark.coordinate, animated: true)
    }
}

extension HomeController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = userLocation.coordinate
        
        self.pickUpLabel.text = "Looking up...."
        
        self.placesService.lookUpCurrent(location: userLocation.location) { (placeMark) in
            self.pickUpLabel.text = placeMark?.name
        }
        self.mapView.setCenter(userLocation.coordinate, animated: true)
        
        if let fromPin = self.fromPin {
            self.mapView.removeAnnotation(fromPin)
        }
        self.fromPin = annotation
        self.mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        //Ensure both from and to locations are set
        guard let _ = self.fromPin, let toPinAnnotation = self.toPin else {
            return nil
        }
        let annotationView = MKPinAnnotationView(annotation:toPinAnnotation, reuseIdentifier:"toPin")
        annotationView.isEnabled = true
        annotationView.canShowCallout = true
        
        annotationView.detailCalloutAccessoryView = getAccessoryView()
        return annotationView
    }
    
    func getAccessoryView() -> UIView {
        let view = UIView()
        let priceLabel = UILabel()
        priceLabel.textColor = UIColor.white
        priceLabel.text = self.pricing
        let timeLabel = UILabel()
        timeLabel.textColor = UIColor.white
        timeLabel.text = "•\(self.eta)"
        view.addSubview(priceLabel)
        view.addSubview(timeLabel)
        
        priceLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 0.0)
        timeLabel.anchor(top: view.topAnchor, left: priceLabel.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 0.0)
        view.backgroundColor = UIColor.blue
        return view
    }
}

extension HomeController {
    
    func fetchPricingAndEta(forLocation location: CLLocationCoordinate2D) {
        let locationModel = Location(lat: location.latitude, lng: location.longitude)
        group.enter()
        porterService.fetchEta(location: locationModel) { (etaResponse) in
            self.eta = "\(etaResponse.eta) min"
            self.group.leave()
        }
        group.enter()
        porterService.fetchPrice(location: locationModel) { (pricingResponse) in
            self.pricing = "Rs \(pricingResponse.cost)"
            self.group.leave()
        }
        
        group.notify(queue: .main) {
            if let toPin = self.toPin{
                self.mapView.selectAnnotation(toPin, animated: true)
            }
        }
    }
}
