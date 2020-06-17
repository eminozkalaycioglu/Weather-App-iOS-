//
//  SearchPlaceViewModel.swift
//  WeatherApp
//
//  Created by Emin on 17.06.2020.
//  Copyright © 2020 Emin. All rights reserved.
//

import Foundation

class SearchPlaceViewModel {
    
    private var foundPlacesModel: PlacesModel?
    var foundPlacesTableViewReloadDataClosure: (()->())?
    
    init() { }
    
    func getPlaces(query: String?) {
        ServiceManager.shared.getPlaces(query: query ?? "") { (result) in
            switch result {
            case .success(let response):
                self.foundPlacesModel = response
                self.foundPlacesTableViewReloadDataClosure?()
                
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
            
        }
    }
    
    func setPlace(at index: IndexPath) {
        if let model = self.foundPlacesModel?.hits![index.row] {
            PlaceData.shared.place = model
        }
        
    }
    
    func getSpecificPlaceInfo(at index: IndexPath) -> PlacesHit {
        return self.foundPlacesModel?.hits?[index.row] ?? PlacesHit()
    }
    
    func getPlaceCount() -> Int {
        return self.foundPlacesModel?.nbHits ?? 0
    }
    
    
}
