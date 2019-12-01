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
    @IBOutlet weak var pickUpValueLabel: UILabel!
    @IBOutlet weak var dropLabel: UILabel!
    @IBOutlet weak var dropValueLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var fromPin: MKAnnotation?
    var toPin: MKAnnotation?
    var pricing: PricingResponse?
    var eta: EtaResponse?
    
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
        setupTitles()
    }
    
    func setupTitles() {
        pickUpValueLabel.text = ""
        dropLabel.text = ""
        dropValueLabel.textColor = .systemGray
        dropValueLabel.text = "To"
    }
    
    private func setupTapGestures() {
        pickUpLabel.isUserInteractionEnabled = true
        pickUpLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapPickupLocation)))
        dropValueLabel.isUserInteractionEnabled = true
        dropValueLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapDropLocation)))
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
    
    func didSelectFrom(location: MKMapItem) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.placemark.coordinate
        self.pickUpValueLabel.text = location.name
        if let fromPin = self.fromPin {
            self.mapView.removeAnnotation(fromPin)
        }
        self.fromPin = annotation
        self.mapView.addAnnotation(annotation)
        self.mapView.setCenter(location.placemark.coordinate, animated: true)
    }
    
    func didSelectTo(location: MKMapItem, pricing: PricingResponse?, eta: EtaResponse?) {
        self.pricing = pricing
        self.eta = eta
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.placemark.coordinate
        self.dropValueLabel.textColor = UIColor.black
        self.dropLabel.text = "To"
        self.dropValueLabel.text = location.name
        if let toPin = self.toPin {
            self.mapView.removeAnnotation(toPin)
        }
        self.toPin = annotation
        self.mapView.addAnnotation(annotation)
        self.mapView.setCenter(location.placemark.coordinate, animated: true)
        self.mapView.selectAnnotation(annotation, animated: true)
    }
}

extension HomeController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = userLocation.coordinate
        
        self.pickUpValueLabel.text = "Looking up...."
        
        self.placesService.lookUpCurrent(location: userLocation.location) { (placeMark) in
            self.pickUpValueLabel.text = placeMark?.name
        }
        self.mapView.setCenter(userLocation.coordinate, animated: true)
        
        if let fromPin = self.fromPin {
            self.mapView.removeAnnotation(fromPin)
        }
        self.fromPin = annotation
        self.mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: self.mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self){
            return nil
        }
        guard let toAnnot = self.toPin, toAnnot.coordinate == annotation.coordinate else {
            return nil
        }
        
        
        let customView = (Bundle.main.loadNibNamed("CustomAnnotationView", owner: self, options: nil))?.first as! CustomAnnotationView
        customView.frame = CGRect(x: 0, y: 0, width: 260, height: 50)
        customView.delegate = self
        if let etaTime = self.eta?.eta {
            customView.etaLabel.text = "\(etaTime) min"
        } else {
            customView.etaLabel.text = ""
        }
        if let cost = self.pricing?.cost {
            customView.priceLabel.text = "Rs \(cost)"
        } else {
            customView.priceLabel.text = ""
        }
        return customView
    }
}

extension HomeController: CustomAnnotationViewDelegate {
    func bookNowTapped() {
        print("tapped")
    }
}


extension CLLocationCoordinate2D: Equatable {}

public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return (lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude)
}
