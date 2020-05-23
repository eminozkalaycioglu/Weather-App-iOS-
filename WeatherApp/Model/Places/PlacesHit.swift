//
//  PlacesHit.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on March 25, 2020

import Foundation

//MARK: - PlacesHit
struct PlacesHit: Decodable {
    
    var geoloc : PlacesGeoloc?
    var administrative : [String]?
    var country : PlacesCountry?
    var countryCode: String?
    var county : PlacesCounty?
    var localeNames : PlacesLocaleName?
    var objectID : String?
    
    enum CodingKeys : String, CodingKey {
        case geoloc = "_geoloc"
        case administrative = "administrative"
        case country = "country"
        case county = "county"
        case localeNames = "locale_names"
        case objectID = "objectID"
        case countryCode = "country_code"
        
    }

        
}

