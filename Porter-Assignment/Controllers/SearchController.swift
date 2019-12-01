//
//  SearchController.swift
//  Porter-Assignment
//
//  Created by Shameek Sarkar on 13/11/19.
//  Copyright © 2019 Shameek Sarkar. All rights reserved.
//

import UIKit
import MapKit
import RTSearchBar
import RappleProgressHUD

protocol SearchControllerDelegate {
    func didSelectFrom(location: MKMapItem)
    func didSelectTo(location: MKMapItem, pricing: PricingResponse?, eta: EtaResponse?)
}

class SearchController: UIViewController {
    
    var pricing: PricingResponse?
    var eta: EtaResponse?
    
    @IBOutlet weak var searchBar: RTSearchBar!
    var searchType: SearchType?
    var delegate: SearchControllerDelegate?
    private var places: [MKMapItem]?
    let group = DispatchGroup()
    
    @IBOutlet weak var titleItem: UINavigationItem!
    
    @IBAction func didTapCancel(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleItem.title = self.searchType?.getTitle()
        initViews()
    }
    
    private func initViews() {
        searchBar.cellStyle = CellTypes.subtitleCell.rawValue
        searchBar.animationDelay = 0.2
        searchBar.dataSource = self
        searchBar.delegate = self
    }
    
    func fetchPricingAndEta(forMKMapItem mapItem: MKMapItem) {
        let locationModel = Location(lat: mapItem.placemark.coordinate.latitude, lng: mapItem.placemark.coordinate.longitude)
        RappleActivityIndicatorView.startAnimatingWithLabel("Fetching Data...")
        group.enter()
        
        ServiceManager.porter.fetchEta(location: locationModel) { (etaResponse) in
            self.eta = etaResponse
            self.group.leave()
        }
        group.enter()
        ServiceManager.porter.fetchPrice(location: locationModel) { (pricingResponse) in
            self.pricing = pricingResponse
            self.group.leave()
        }
        
        group.notify(queue: .main) {
            RappleActivityIndicatorView.stopAnimation()
            self.delegate?.didSelectTo(location: mapItem, pricing: self.pricing, eta: self.eta)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension SearchController: RTSearchBarDataSource {
    func getData() -> [Any]? {
        return self.places
    }
    
    func textToDisplay(forData data: Any) -> String? {
        guard let place = data as? MKMapItem else {
            return nil
        }
        return place.name
    }
}

extension SearchController: RTSearchBarDelegate {
    
    func didChange(text: String) {
        ServiceManager.places.search(query: text) { (places) in
            self.places = places
            self.searchBar.reload()
        }
    }
    
    func didSelect(withData data: Any) {
        guard let item = data as? MKMapItem, let searchType = self.searchType else {
            return
        }
        if searchType == .from {
            self.delegate?.didSelectFrom(location: item)
            dismiss(animated: true, completion: nil)
        } else {
            self.fetchPricingAndEta(forMKMapItem: item)
        }
    }
    
    func decorate(cell: UITableViewCell, forData data: Any) -> UITableViewCell {
        guard let item = data as? MKMapItem else {
            return cell
        }
        cell.detailTextLabel?.text = item.placemark.title
        return cell
    }
}
