//
//  DetailViewModel.swift
//  WeatherApp
//
//  Created by Emin on 16.06.2020.
//  Copyright © 2020 Emin. All rights reserved.
//

import Foundation

class DetailViewModel {
    private var forecast: [ForecastList]?
    
    var hourIs12Closure: ((_ temp: Int, _ weatherIcon: String)->())?
    var hourIs9Closure: ((_ temp: Int)->())?
    var hourIs21Closure: ((_ temp: Int)->())?
    
    init() {}
    
    func setForecast(forecast: [ForecastList]) {
        self.forecast = forecast
    }
    
    func getHourAndMinute(at index: IndexPath) -> DateComponents? {
        return self.forecast?[index.row].dtTxt?.stringToDate().getHourAndMinute()
    }
    
    func getForecastCount() -> Int {
        return self.forecast?.count ?? 0
    }
    
    func getNameOfDay() -> String {
        guard let date = self.forecast?[0].dtTxt?.stringToDate() else {
            return ""
        }
        return DateToDay.shared.getNameOfDayFromDate(date: date)
    }
    
    func getSpecificForecastWeatherIcon(at index: IndexPath) -> String {
        guard let icon = self.forecast?[index.row].weather?[0].icon else {
            return "noIcon"
        }
        
        return "a" + icon
    }
    
    func getSpecificForecastTemp(at index: IndexPath) -> Float? {
        let temp = self.forecast?[index.row].main?.temp
        return temp
    }
    
    func setMainForecast() {
        for item in self.forecast! {
            let hour = item.dtTxt?.stringToDate().getHour()
            
            if hour == 12 {
                let weatherIcon: String!
                if let icon = (item.weather?.first?.icon) {
                    weatherIcon = "a" + icon
                }
                else {
                    weatherIcon = "noIcon"
                }
                self.hourIs12Closure?(Int(item.main?.temp ?? 0), weatherIcon)
            }
            
            if hour == 6 {
                self.hourIs9Closure?(Int(item.main?.temp ?? 0))
            }
            
            if hour == 21 {
                self.hourIs21Closure?(Int(item.main?.temp ?? 0))
            }
        }
    }
}
