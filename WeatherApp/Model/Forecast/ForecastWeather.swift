//
//  ForecastWeather.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on April 3, 2020

import Foundation

//MARK: - ForecastWeather
struct ForecastWeather: Decodable {

    var descriptionField : String?
    var icon : String?
    var id : Int?
    var main : String?
    
    enum CodingKeys : String, CodingKey {
        case icon = "icon"
        case id = "id"
        case main = "main"
        case descriptionField = "description"
        
        
        
    }
}
