//
//  Date.swift
//  
//
//  Created by Mac10 on 2022/04/01.
//

import Foundation

extension Date{
    func truncate(_ comps:Set<Calendar.Component>, calendar: Calendar)->Date{
        let dateComponents = calendar.dateComponents(comps, from: self)
        return calendar.date(from: dateComponents)!
    }

    func truncate(_ comps:Set<Calendar.Component>)->Date{
        truncate(comps, calendar: Calendar(identifier: .gregorian))
    }

    func truncateHms(calendar: Calendar) -> Date{
        truncate([.year, .month, .day], calendar: calendar)
    }
    
    func truncateHms() -> Date{
        truncateHms(calendar: Calendar(identifier: .gregorian))
    }

    func getYmdhms(calendar: Calendar) -> Ymdhms?{
        let dateComponents = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: self)
        if let year = dateComponents.year,
           let month = dateComponents.month,
           let day = dateComponents.day,
           let hour = dateComponents.hour,
           let minute = dateComponents.minute,
           let second = dateComponents.second {
            return Ymdhms(year: year, month: month, day: day, hour: hour, minute: minute, second: second)
        }
        return nil
    }
    
    func getYmdhms() -> Ymdhms?{
        getYmdhms(calendar: Calendar(identifier: .gregorian))
    }
    struct Ymdhms{
        let year:Int
        let month:Int
        let day:Int
        let hour:Int
        let minute:Int
        let second:Int
    }
}
