//
//  MMHeatmapView.swift
//  Diarrrrrrrrrry
//
//  Created by Mac10 on 2021/04/13.
//  Copyright © 2021 s-n-1-0. All rights reserved.
//

import SwiftUI

public struct MMHeatmapView: View {
    public init(start _start:Date,
                end _end:Date? = nil,
                data _data:[MMHeatmapData],
                style:MMHeatmapStyle = MMHeatmapStyle(baseCellColor: .label),
                layout:MMHeatmapLayout = MMHeatmapLayout(),
                calendar: Calendar = Calendar(identifier: .gregorian),
                locale: Locale? = nil,
                timeZone: TimeZone? = nil
    ){
        var cal = calendar
        if let timeZone {
            cal.timeZone = timeZone
        }
        let start = _start.truncate([.year,.month], calendar: cal)
        let startYear = cal.component(.year, from: start)
        let startMonth = cal.component(.month, from: start)
        let end = (_end ?? Date()).truncateHms(calendar: cal)
        let formatter = DateFormatter()
        formatter.dateFormat = style.dateMMFormat
        formatter.calendar = cal
        formatter.locale = locale ?? .autoupdatingCurrent
        formatter.timeZone = timeZone ?? cal.timeZone
        let data = _data.dateRange(start: start, end: end)
        self.displayFormatter = formatter
        self.start = start
        self.end = end
        self.yyyy = startYear
        self.MM = startMonth
        self.data = data.compactMap{
            item in
            if let elapsedDay = cal.dateComponents([.day],from:start,to:item.date).day{
                return MMHeatmapElapsedData(elapsedDay: elapsedDay, value: item.value)
            }else{
                return nil
            }
        }
        //x月1日基準で差を求める
        self.range = cal.monthRange(start: start, end: end)
        self.maxElapsedDay = style.clippedWithEndDate ? cal.dateComponents([.day],from:start,to:end).day: nil
        self.maxValue = data.max(by:{
            (a, b) -> Bool in
            a.value < b.value
        })?.value ?? 10
        self.style = style
        self.calendar = cal
        self.sundayLabelIndex = MMHeatmapView.weekdayIndex(weekday: 1, firstWeekday: cal.firstWeekday)
        self.saturdayLabelIndex = MMHeatmapView.weekdayIndex(weekday: 7, firstWeekday: cal.firstWeekday)
        self.safeWeekLabels = MMHeatmapView.normalizedWeekLabels(style.week)
        self._layout = ObservedObject(initialValue: layout)
    }
    @ObservedObject var style:MMHeatmapStyle
    @ObservedObject var layout:MMHeatmapLayout
    let calendar: Calendar
    let displayFormatter:DateFormatter
    let start:Date
    let end:Date
    let yyyy:Int
    let MM:Int
    let data:[MMHeatmapElapsedData]
    let range:Int
    let maxValue:Int
    let maxElapsedDay:Int?
    let sundayLabelIndex:Int
    let saturdayLabelIndex:Int
    let safeWeekLabels:[String]
    public var body: some View {
        HStack(alignment:.bottom){
            VStack{
                Text(safeWeekLabels[0])
                    .font(.system(size: layout.mmLabelHeight))
                    .foregroundColor(labelColor(at: 0))
                Spacer()
                Text(safeWeekLabels[3])
                    .font(.system(size: layout.mmLabelHeight))
                    .foregroundColor(labelColor(at: 3))
                Spacer()
                Text(safeWeekLabels[6])
                    .font(.system(size: layout.mmLabelHeight))
                    .foregroundColor(labelColor(at: 6))
            }.frame(height: layout.columnHeight).layoutPriority(1)
            HStack(alignment:.bottom,spacing: 0){
                ForEach( MM ..< (MM + range),id:\.self){
                    i in
                    VStack(spacing:0){
                        Text(getMMLabel(MM: i)).font(.system(size: layout.mmLabelHeight)) // actual pixel size: -4 //why???
                            .fixedSize(horizontal: true, vertical: false).padding([.top,.bottom],layout.mmLabelVSpacing)
                        MMHeatmapMonthView(yyyy: yyyy, startMM: MM, MM: i,data:data, maxValue: maxValue,maxElapsedDay:maxElapsedDay, calendar: calendar)
                    }.frame(alignment:.bottom).id("MMHeatmapView:\(i)")
                    if(i != (MM + range - 1)){
                        Divider().frame(width:layout.dividerWidth,height: layout.cellSize*7 + layout.cellSpacing*6).offset(x:0,y:15)
                    }
                }
            }.modifier(Scroll14(isScroll:style.isScroll, innerContentWidth: layout.calcMMHeatmapViewContentWidth(start: start, end: end, calendar: calendar),idx:MM + range - 1))
        }.frame(alignment:.leading).environmentObject(style).environmentObject(layout)
    }
    
    func getMMLabel(MM:Int)->String{
        var comp = DateComponents()
        comp.year = yyyy
        comp.day = 1
        comp.month = MM
        if let date = calendar.date(from: comp){
            return displayFormatter.string(from: date)
        }else{
            return "\(MM)"
        }
    }

    func labelColor(at index:Int) -> Color {
        if index == sundayLabelIndex {
            return Color(UIColor.systemRed)
        }
        if index == saturdayLabelIndex {
            return Color(UIColor.systemBlue)
        }
        return Color.primary
    }

    static func weekdayIndex(weekday: Int, firstWeekday: Int) -> Int {
        (weekday - firstWeekday + 7) % 7
    }

    static func normalizedWeekLabels(_ labels: [String]) -> [String] {
        if labels.count == 7 {
            return labels
        }
        return ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    }
}

fileprivate struct Scroll14:ViewModifier{
    let isScroll:Bool
    let innerContentWidth:CGFloat
    let idx:Int
    @EnvironmentObject var layout:MMHeatmapLayout
    @ViewBuilder func body(content: Content) -> some View {
        Group{
            if #available(iOS 14.0, *),isScroll{
                ScrollView(.horizontal){
                    ScrollViewReader{
                        proxy in
                        content.onAppear{
                            proxy.scrollTo("MMHeatmapView:\(idx)", anchor: .trailing)
                        }
                    }
                }
            }else{
                content.modifier(DisabledScroll(innerContentWidth: innerContentWidth))
            }
        }.frame(maxWidth:innerContentWidth)
    }
}

fileprivate struct DisabledScroll:ViewModifier{
    let innerContentWidth:CGFloat
    @EnvironmentObject var layout:MMHeatmapLayout
    func body(content: Content) -> some View {
        GeometryReader{
            gp in
            content.frame(width:gp.size.width < innerContentWidth ? gp.size.width : innerContentWidth,height:layout.mmHeatmapViewHeight,alignment: .trailing).clipped()
        }.frame(height:layout.mmHeatmapViewHeight)
    }
}
