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

protocol SearchControllerDelegate {
    func didSelect(location: MKMapItem)
}

class SearchController: UIViewController {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var searchBar: RTSearchBar!
    
    var delegate: SearchControllerDelegate?
    private var places: [MKMapItem]?
    /* Service */
    private var placesService: PlacesService = MapKitPlacesService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    private func initViews() {
        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        searchBar.dataSource = self
        searchBar.delegate = self
    }
    
    @objc private func didTapCancel() {
        dismiss(animated: true)
    }
}

extension SearchController: RTSearchBarDataSource {
    func getData() -> [Any]? {
        return self.places
    }
    
    func textToBeShown(forData data: Any) -> String? {
        guard let place = data as? MKMapItem else {
            return nil
        }
        return place.name
    }
}

extension SearchController: RTSearchBarDelegate {
    
    func didChange(text: String) {
        placesService.search(query: text) { (places) in
            self.places = places
            self.searchBar.reload()
        }
    }
    
    func didSelect(withData data: Any) {
        guard let item = data as? MKMapItem else {
            return
        }
        self.delegate?.didSelect(location: item)
        dismiss(animated: true, completion: nil)
    }
    
    func didEndEditing(text: String) {}
    func didClear() {}
}
