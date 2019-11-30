//
//  SearchController.swift
//  Porter-Assignment
//
//  Created by Shameek Sarkar on 13/11/19.
//  Copyright © 2019 Shameek Sarkar. All rights reserved.
//

import UIKit
import RTSearchBar

class SearchController: UIViewController {
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var searchBar: RTSearchBar!
    
  /* Service */
  private var placesService: PlacesService = MapKitPlacesService()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initViews()
  }
  
  private func initViews() {
    cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
    searchBar.RSBDelegate = self
    searchBar.RSBDataSource = self
  }
  
  @objc private func didTapCancel() {
    dismiss(animated: true)
  }
}

extension SearchController: RTSearchBarDataSource {
    func getData() -> [Any]? {
        
    }
    
    func textToBeShown(forData data: Any) -> String? {
        
    }
}

extension SearchController: RSBDelegate {
    func didChange(text: String) {
        
    }
    
    func didEndEditing(text: String) {
        
    }
    
    func didSelect(withData data: Any) {
        
    }
    
    func didClear() {
        
    }
    
    func didPaste(text: String) {
        
    }
}
