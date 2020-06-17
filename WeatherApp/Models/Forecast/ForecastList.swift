

import Foundation

//MARK: - ForecastList
struct ForecastList: Decodable {

    var clouds : ForecastCloud?
    var dtTxt : String?
    var main : ForecastMain?
    var rain : ForecastRain?
    var weather : [ForecastWeather]?
    var wind : ForecastWind?
    
    enum CodingKeys : String, CodingKey {
        case clouds = "clouds"
        case dtTxt = "dt_txt"
        case main = "main"
        case rain = "rain"
        case weather = "weather"
        case wind = "wind"
        
        
    }
        
}


