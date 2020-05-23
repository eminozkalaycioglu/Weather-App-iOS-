//
//  DateExtension.swift
//  WeatherApp
//
//  Created by Emin on 19.05.2020.
//  Copyright © 2020 Emin. All rights reserved.
//

import Foundation


extension Date {
    func isHour12() -> Bool {
        
        let hour = Calendar.current.component(.hour, from: self)
        if hour == 12 {
            return true
        }
        return false
        
        
    }
    
    func getHour() -> Int {
        
        let hour = Calendar.current.component(.hour, from: self)
        return hour
    }
    
    
    
    func daysBetweenDates(endDate: Date) -> Int
    {
        let calendar = Calendar.current
        
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: endDate)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        guard let day = components.day else { return 0 }
        
        return day
    }
}
