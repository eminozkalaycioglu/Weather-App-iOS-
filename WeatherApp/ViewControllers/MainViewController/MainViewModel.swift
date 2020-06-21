//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Emin on 16.06.2020.
//  Copyright © 2020 Emin. All rights reserved.
//

import Foundation
import CoreLocation

class MainViewModel {
    private var forecastModel: ForecastModel?
    private var extractedForecastList: [ExtractedForecast]?
    private var nextDaysForecastList: [[ForecastList]]?
    private var todayForecast: ForecastList?
    private let colorsArray: [[String]] = [
        ["#FF416C","#FF4B2B"],
        ["#9370DB","#2F0743"],
        ["#6DCA98","#005528"],
        ["#f5af19","#f12711"],
        ["#FF416C","#FF4B2B"],
        ["#9370DB","#2F0743"],
        ["#6DCA98","#005528"],
        ["#f5af19","#f12711"]
        
    ]
    let locationManager = CLLocationManager()
    private var currentLocation: CLLocation!
    var setTodayForecastViewClosure: (()->())?
    var reloadDataNextDaysCollectionViewClosure: (()->())?
    var setAnimateClosure: ((_ status: Bool)->())?
    var setSelectedPlaceLabelTextClosure: (( _ administrative: String, _ countryCode: String)->())?
    init() {}
    
    func getTodayForecast() -> ForecastList {
        return self.todayForecast!
    }
    
    func getSpecificDayForecast(at index: IndexPath) -> [ForecastList]? {
        return self.nextDaysForecastList?[index.row]
    }
    
    func getExtractedForecastList(at index: IndexPath) -> ExtractedForecast? {
        return self.extractedForecastList?[index.row]
    }
    
    func getExtractedForecastListCount() -> Int {
        return self.extractedForecastList?.count ?? 0
    }
    
    func getColors(at index: IndexPath) -> [String] {
        return colorsArray[index.row]
    }
    func getWeatherInfo() {
        let place = PlaceData.shared.place
        self.setSelectedPlaceLabelTextClosure?((place?.administrative?[0] ?? ""), (place?.countryCode?.uppercased() ?? ""))
        
        guard let lat = place?.geoloc?.lat, let lon = place?.geoloc?.lng else { return }

        ServiceManager.shared.getForecast(lat: lat, lon: lon) { (result) in
            switch result {
            case .success(let response):
                
                self.forecastModel = response
                self.extractedForecastList = self.extractForecast(forecast: response)
                self.nextDaysForecastList = self.extractForecastAsNextDays(forecast: response)
                self.todayForecast = self.findTodayForecast(forecast: self.forecastModel ?? ForecastModel())
                self.setTodayForecastViewClosure?()
                self.reloadDataNextDaysCollectionViewClosure?()
                self.setAnimateClosure?(false)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    private func getCurrentLocation() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() ==  .authorizedAlways {
            currentLocation = self.locationManager.location
        }
        
    }
    
    
    func getDefaultPlace() {
        self.getCurrentLocation()
        if let loc = self.currentLocation {
            ServiceManager.shared.getPlaceFromCoord(lat: Float(loc.coordinate.latitude), lon: Float(loc.coordinate.longitude)) { (result) in
                switch result {
                case .success(let response):
                    PlaceData.shared.place = response.hits?[0]
                    self.getWeatherInfo()
                    
                case .failure(let error):
                    debugPrint(error.localizedDescription)

                }
            }
        }
        else {
            ServiceManager.shared.getPlaces(query: PlaceData.shared.defaultQuery) { (result) in
                
                switch result {
                case .success(let response):
                    PlaceData.shared.place = response.hits?[0]
                    self.getWeatherInfo()
                    
                    
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                    
                }
                
            }
        }
        
    }
    
//    this func is extracting 3 time periods from crude forecast (as morning, night and noon) to show every next days cell
    private func extractForecast(forecast: ForecastModel) -> [ExtractedForecast] {
        var tempForecast = forecast
        
        let dateOfToday = tempForecast.list?[0].dtTxt?.stringToDate()
        while (dateOfToday?.daysBetweenDates(endDate: (tempForecast.list?[0].dtTxt?.stringToDate())!))! < 1 {
            tempForecast.list?.remove(at: 0)
            
        }
        var extractedList: [ExtractedForecast] = [ExtractedForecast()]
        extractedList.remove(at: 0)
        var extracted: ExtractedForecast = ExtractedForecast()
        for tempForecasts in tempForecast.list! {
            let hour = tempForecasts.dtTxt?.stringToDate().getHour()
            
            if hour == 12 {
                extracted.forecastOfDay = tempForecasts
                continue
            }
            if hour == 6 {
                extracted.morningForecastOfDay = tempForecasts
                continue
            }
            if hour == 21 {
                extracted.nightForecastOfDay = tempForecasts
                extractedList.append(extracted)
                
            }
        }
        return extractedList
    }
    
//    this func is converting crude forecast to divided days for send to detail viewcontroller when the client select a day
    private func extractForecastAsNextDays(forecast: ForecastModel) -> [[ForecastList]] {
        var tempForecast = forecast
        
        let dateOfToday = tempForecast.list?[0].dtTxt?.stringToDate()
        while (dateOfToday?.daysBetweenDates(endDate: (tempForecast.list?[0].dtTxt?.stringToDate())!))! < 1 {
            tempForecast.list?.remove(at: 0)
        }
        
        var extractedList = [[ForecastList()]]
        extractedList.remove(at: 0)
        var extracted = [ForecastList()]
        extracted.remove(at: 0)
        
        for item in tempForecast.list! {
            if extractedList.count == self.extractedForecastList?.count {
                break
            }
            extracted.append(item)
            
            if item.dtTxt?.stringToDate().getHour() == 21  {
                extractedList.append(extracted)
                extracted.removeAll()
            }
        }
        
        return extractedList
        
    }
    
    private func findTodayForecast(forecast: ForecastModel) -> ForecastList {
    
        let dateOfToday = forecast.list?[0].dtTxt?.stringToDate()
    
        for forecastItem in forecast.list! {
            if (dateOfToday?.daysBetweenDates(endDate: (forecastItem.dtTxt?.stringToDate())!) == 0) && forecastItem.dtTxt?.stringToDate().getHour() == 12 {
                return forecastItem
            }
        }
        return (forecast.list?[0])!
    }
    
}

