//
//  ForecastMain.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on April 3, 2020

import Foundation

//MARK: - ForecastMain
struct ForecastMain: Decodable {

    var feelsLike : Float?
    var grndLevel : Int?
    var humidity : Int?
    var pressure : Int?
    var seaLevel : Int?
    var temp : Float?
    var tempKf : Float?
    var tempMax : Float?
    var tempMin : Float?
    
    enum CodingKeys : String, CodingKey {
        case feelsLike = "feels_like"
        case grndLevel = "grnd_level"
        case humidity = "humidity"
        case pressure = "pressure"
        case seaLevel = "sea_level"
        case temp = "temp"
        case tempKf = "temp_kf"
        case tempMax = "temp_max"
        case tempMin = "temp_min"
        
        
    }
        
}

