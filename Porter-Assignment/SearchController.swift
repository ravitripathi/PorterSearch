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
    func didSelect(location: MKMapItem, searchType: SearchType)
}

class SearchController: UIViewController {
    @IBOutlet weak var searchBar: RTSearchBar!
    var searchType: SearchType?
    var delegate: SearchControllerDelegate?
    private var places: [MKMapItem]?
    @IBOutlet weak var titleItem: UINavigationItem!
    
    @IBAction func didTapCancel(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    private var placesService: PlacesService = MapKitPlacesService()
    
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
        placesService.search(query: text) { (places) in
            self.places = places
            self.searchBar.reload()
        }
    }
    
    func didSelect(withData data: Any) {
        guard let item = data as? MKMapItem, let searchType = self.searchType else {
            return
        }
        self.delegate?.didSelect(location: item, searchType: searchType)
        dismiss(animated: true, completion: nil)
    }
    
    func decorate(cell: UITableViewCell, forData data: Any) -> UITableViewCell {
        guard let item = data as? MKMapItem else {
            return cell
        }
        cell.detailTextLabel?.text = item.placemark.title
        return cell
    }
}
