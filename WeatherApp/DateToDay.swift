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
    
    func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    private init() {
        
    }
    
    
}
