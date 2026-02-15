//
//  Calendar.swift
//
//
//  Created by s-n-1-0 on 2024/03/30.
//

import Foundation
extension Calendar{
    /**
     Example:
     year: 2024, month: 3
     => Date[2024/3/31]
     */
    func lastDateOfMonth(year:Int,month:Int)->Date{
        var comp = DateComponents()
        comp.year = year
        comp.month = month + 1
        comp.day = 0
        // 0 = 前の月の最終日
        return self.date(from: comp)!
    }
    
    func monthRange(start:Date,end:Date)->Int{
        self.dateComponents([.month],
                            from: start.truncate([.year,.month], calendar: self),
                            to:end.truncate([.year,.month], calendar: self)).month! + 1
        
    }

    func heatmapWeekdayIndex(for date: Date) -> Int {
        let weekday = component(.weekday, from: date)
        return (weekday - firstWeekday + 7) % 7
    }

    func heatmapWeekColumnCount(year: Int, month: Int) -> Int {
        let firstDate = date(from: DateComponents(year: year, month: month, day: 1))!
        let lastDate = lastDateOfMonth(year: year, month: month)
        let leadingDays = heatmapWeekdayIndex(for: firstDate)
        let daysInMonth = component(.day, from: lastDate)
        return (leadingDays + daysInMonth + 6) / 7
    }
}
