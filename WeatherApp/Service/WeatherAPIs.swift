
import Foundation
import Moya

enum WeatherAPI {
    
    case getPlaces(query: String)
    case getForecast(lat: Float, lon: Float)
}


extension WeatherAPI: TargetType {
    
    var weatherApiKey: String {
        switch self {
        case .getForecast( _, _):
            return "ceb746300d424b32f082ff50b295aa2e"
        default:
            return ""
        }
        
    }
    
    public var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

    public var baseURL: URL {
        switch self {
        case .getPlaces( _):
            return URL(string: "https://places-dsn.algolia.net/1")!
            
        case .getForecast( _, _):
            return URL(string: "https://api.openweathermap.org/data/2.5")!
        }
        
    }

    public var path: String {
        switch self {
        case .getPlaces( _):
            return "/places/query"
        case .getForecast( _, _):
            return "/forecast"
        }
    }

    public var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }

    public var sampleData: Data {
        return Data()
    }

    public var task: Task {
        switch self {

        case .getPlaces(let query):
            return .requestParameters(
                parameters: [
                    "query": query,
                    "type": "city",
                    "countries": "tr"
                    ] ,
                encoding: URLEncoding.default)
            
        case .getForecast(let lat, let lon):
            return .requestParameters(
                parameters: [
                    "lat": lat.description,
                    "lon": lon.description,
                    "appid": self.weatherApiKey,
                    "units": "metric"
                ] ,
                encoding: URLEncoding.default)
            
        
        }
    }
}

