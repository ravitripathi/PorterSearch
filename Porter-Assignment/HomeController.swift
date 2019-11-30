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
  @IBOutlet weak var pickupButton: UIButton!
  @IBOutlet weak var dropButton: UIButton!
  
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var bookButton: UIButton!
  
  /* Service */
  private var porterService: PorterService = HttpPorterService()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initViews()
  }
  
  private func initViews() {
    pickupButton.addTarget(self, action: #selector(self.didTapPickupLocation), for: .touchUpInside)
    dropButton.addTarget(self, action: #selector(self.didTapDropLocation), for: .touchUpInside)
    bookButton.addTarget(self, action: #selector(self.didTapBook), for: .touchUpInside)
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
