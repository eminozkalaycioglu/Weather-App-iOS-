//
//  SearchPlaceViewController.swift
//  WeatherApp
//
//  Created by Emin on 27.03.2020.
//  Copyright © 2020 Emin. All rights reserved.
//

import UIKit

class SearchPlaceViewController: UIViewController {

    @IBOutlet weak var searchBarOutlet: UISearchBar!
    @IBOutlet weak var foundPlacesTableView: UITableView!
    
    lazy var viewModel: SearchPlaceViewModel = {
        return SearchPlaceViewModel()
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.foundPlacesTableView.keyboardDismissMode = .onDrag
        self.foundPlacesTableView.delegate = self
        self.foundPlacesTableView.dataSource = self
        self.foundPlacesTableView.register(UINib(nibName: "FoundPlacesTableViewCell", bundle: nil), forCellReuseIdentifier: "FoundPlacesTableViewCell")
        
        self.searchBarOutlet.delegate = self
        self.searchBarOutlet.becomeFirstResponder()
        
        
        self.viewModel.foundPlacesTableViewReloadDataClosure = {
            [weak self] () in
            DispatchQueue.main.async {
                self?.foundPlacesTableView.reloadData()
            }
        }
    }
    
}

extension SearchPlaceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getPlaceCount()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.setPlace(at: indexPath)
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoundPlacesTableViewCell", for: indexPath)  as! FoundPlacesTableViewCell
        let place = self.viewModel.getSpecificPlaceInfo(at: indexPath)
        
        cell.firsstPartOfAddress.text = (place.localeNames?.defaultField?[0] ?? "") + ", " + (place.county?.defaultField?[0] ?? "")
        
        cell.secondPartOfAddress.text = (place.administrative?[0] ?? "") + ", " + (place.country?.defaultField ?? "")
        
        return cell
    }
    
}

extension SearchPlaceViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.getPlaces(query: self.searchBarOutlet.text)
    }
    
    
}
