//
//  MMHeatmapStyle.swift
//  
//
//  Created by s-n-1-0 on 2023/10/29.
//

import SwiftUI

public enum MMHeatmapWeekdaySymbolStyle {
    case veryShort
    case short
    case full
}

public class MMHeatmapStyle:ObservableObject{
    public init(baseCellColor:UIColor,
                minCellColor:UIColor = UIColor.secondarySystemBackground,
                week:[String] = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"],
                dateMMFormat:String = "MMM",
                clippedWithEndDate:Bool = true,
                isScroll:Bool = true) {
        self.minCellColor = minCellColor
        self.baseCellColor = baseCellColor
        self.week = week
        self.dateMMFormat = dateMMFormat
        self.clippedWithEndDate = clippedWithEndDate
        self.isScroll = isScroll
    }
    @Published public var minCellColor:UIColor
    @Published public var baseCellColor:UIColor
    let clippedWithEndDate:Bool
    let isScroll:Bool
    public let week:[String]
    public let dateMMFormat:String

    public static func localizedWeekSymbols(
        calendar: Calendar = Calendar(identifier: .gregorian),
        locale: Locale = .autoupdatingCurrent,
        style: MMHeatmapWeekdaySymbolStyle = .short
    ) -> [String] {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = locale
        let weekdaySymbols: [String]
        switch style {
        case .veryShort:
            weekdaySymbols = formatter.veryShortStandaloneWeekdaySymbols
        case .short:
            weekdaySymbols = formatter.shortStandaloneWeekdaySymbols
        case .full:
            weekdaySymbols = formatter.standaloneWeekdaySymbols
        }
        let startIndex = max(min(calendar.firstWeekday - 1, 6), 0)
        return Array(weekdaySymbols[startIndex...]) + Array(weekdaySymbols[..<startIndex])
    }
}
