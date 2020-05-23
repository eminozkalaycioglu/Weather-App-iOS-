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
    
    var foundPlacesModel: PlacesModel?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.foundPlacesTableView.delegate = self
        self.foundPlacesTableView.dataSource = self
        self.foundPlacesTableView.register(UINib(nibName: "FoundPlacesTableViewCell", bundle: nil), forCellReuseIdentifier: "FoundPlacesTableViewCell")
        
        
        self.searchBarOutlet.delegate = self
        self.searchBarOutlet.becomeFirstResponder()
    }


    

}

extension SearchPlaceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.foundPlacesModel?.nbHits ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = self.foundPlacesModel?.hits![indexPath.row] else {
            return
        }
        PlaceData.shared.place = model
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoundPlacesTableViewCell", for: indexPath)  as! FoundPlacesTableViewCell
        cell.firsstPartOfAddress.text = (self.foundPlacesModel?.hits?[indexPath.row].localeNames?.defaultField?[0] ?? "") + ", " + (self.foundPlacesModel?.hits?[indexPath.row].county?.defaultField?[0] ?? "")
        
        cell.secondPartOfAddress.text = (self.foundPlacesModel?.hits?[indexPath.row].administrative?[0] ?? "") + ", " + (self.foundPlacesModel?.hits?[indexPath.row].country?.defaultField ?? "")
        
        return cell
    }
    
    
    
}

extension SearchPlaceViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
       
        print(" CVB DidBeginEditing")
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("CVB textDidChange")
        
        ServiceManager.shared.getPlaces(query: self.searchBarOutlet.text ?? "") { (result) in
            switch result {
            case .success(let response):
                self.foundPlacesModel = response
                self.foundPlacesTableView.reloadData()
                
                
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
            
        }
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("CVB DidEndEditing")
        
    }
    
    
    
}
