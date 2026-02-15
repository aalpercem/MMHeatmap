//
//  MMHeatmapMonthView.swift
//
//  Created by Mac10 on 2021/04/13.
//  Copyright © 2021 s-n-1-0. All rights reserved.
//

import SwiftUI

struct MMHeatmapMonthView: View {
    init(yyyy:Int,startMM:Int,MM:Int,data:[MMHeatmapElapsedData],maxValue:Int,maxElapsedDay:Int?,calendar: Calendar) {
        var comp = DateComponents()
        comp.year = yyyy
        comp.month = startMM
        comp.day = 1
        startDate = calendar.date(from: comp)
            ?? calendar.date(from: DateComponents(year: yyyy, month: MM, day: 1))
            ?? Date()
        self.yyyy = yyyy
        self.MM = MM
        let dataByElapsedDay = Dictionary(uniqueKeysWithValues: data.map { ($0.elapsedDay, $0.value) })
        self.grid = MMHeatmapMonthGrid.build(
            year: yyyy,
            month: MM,
            startDate: startDate,
            dataByElapsedDay: dataByElapsedDay,
            maxElapsedDay: maxElapsedDay,
            calendar: calendar
        )
        self.calendar = calendar
        self.maxValue = maxValue
    }
    @EnvironmentObject var layout:MMHeatmapLayout
    
    let calendar:Calendar
    let yyyy:Int
    let MM:Int
    let grid: MMHeatmapMonthGrid
    let startDate:Date
    let maxValue:Int
    var body: some View {
        HStack(spacing:layout.cellSpacing){
            ForEach(Array(grid.valuesByColumn.enumerated()),id:\.offset){ item in
                let values = item.element
                MMHeatmapWeekView(startIdx: 0, endIdx: 6, values: values, maxValue: maxValue)
            }
        }
    }
}

#Preview {
    MMHeatmapMonthView(yyyy: 2021, startMM: 2, MM: 2,data:[
        MMHeatmapElapsedData(elapsedDay: 0, value: 5),
        MMHeatmapElapsedData(elapsedDay: 1, value: 7)
    ], maxValue: 10,maxElapsedDay: 20, calendar: Calendar(identifier: .gregorian)).environmentObject(MMHeatmapStyle(baseCellColor: UIColor.black)).environmentObject(MMHeatmapLayout())
}
