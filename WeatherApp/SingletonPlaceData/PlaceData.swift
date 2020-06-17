//
//  Data.swift
//  WeatherApp
//
//  Created by Emin on 29.03.2020.
//  Copyright © 2020 Emin. All rights reserved.
//

import Foundation
class PlaceData {
    
    static let shared: PlaceData = PlaceData()
    
    var place: PlacesHit?
    
    var defaultQuery: String {
        return "Adana"
    }
    
    private init() {
        
    }

    
}
