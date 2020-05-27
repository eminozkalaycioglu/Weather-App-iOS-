//
//  DateToDay.swift
//  WeatherApp
//
//  Created by Emin on 18.05.2020.
//  Copyright © 2020 Emin. All rights reserved.
//

import Foundation

class DateToDay {
    
    static let shared = DateToDay()
    
    
    func getNameOfDay(dayOfWeek: Int) -> String {
        switch dayOfWeek {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            return ""
        }
    }
    
    func getDayOfWeek(todayDate: Date) -> Int {
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    func getNameOfDayFromDate(date: Date) -> String{
        let dayOfWeek = self.getDayOfWeek(todayDate: date)
        let nameOfDay = self.getNameOfDay(dayOfWeek: dayOfWeek)
        return nameOfDay
        
    }
    
    
    private init() {
        
    }
    
    
}
