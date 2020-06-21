
import Foundation
import Moya
import Result

typealias APIResult<T> = Result<T,MoyaError>

public final class ServiceManager {
    
    fileprivate let provider = MoyaProvider<WeatherAPI>(plugins: [NetworkLoggerPlugin()])
    
    fileprivate var jsonDecoder = JSONDecoder()

    public static let shared = ServiceManager()

    fileprivate func fetch<M: Decodable>(target: WeatherAPI,
                                         completion: @escaping (_ result: APIResult<M>) -> Void ) {

        provider.request(target) { (result) in

            switch result {
            case .success(let response):

                do {

                    let filteredResponse = try response.filterSuccessfulStatusCodes()
                    let mappedResponse = try filteredResponse.map(M.self,
                                                                  atKeyPath: nil,
                                                                  using: self.jsonDecoder,
                                                                  failsOnEmptyData: false)
                    completion(.success(mappedResponse))
                } catch MoyaError.statusCode(let response) {
                    if response.statusCode == 401 {

                    }
                    completion(.failure(MoyaError.statusCode(response)))
                } catch {
                    debugPrint("##ERROR parsing##: \(error.localizedDescription)")
                    let moyaError = MoyaError.requestMapping(error.localizedDescription)
                    completion(.failure(moyaError))
                }
            case .failure(let error):
                debugPrint("##ERROR service:## \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    

    func getPlaces(query: String,completion: @escaping (_ result: APIResult<PlacesModel>) -> Void) {
        fetch(target: .getPlaces(query: query), completion: completion)
    }
    
    func getPlaceFromCoord(lat: Float, lon: Float,completion: @escaping (_ result: APIResult<PlacesModel>) -> Void) {
        fetch(target: .getPlaceFromCoord(lat: lat, lon: lon), completion: completion)
    }
    
    func getForecast(lat: Float, lon: Float, completion: @escaping (_ result: APIResult<ForecastModel>) -> Void) {
        fetch(target: .getForecast(lat: lat, lon: lon), completion: completion)
    
    }
    
    

}



