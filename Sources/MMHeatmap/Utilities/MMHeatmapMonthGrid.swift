import Foundation

struct MMHeatmapMonthGrid {
    let valuesByColumn: [[Int?]]

    static func build(
        year: Int,
        month: Int,
        startDate: Date,
        dataByElapsedDay: [Int: Int],
        maxElapsedDay: Int?,
        calendar: Calendar
    ) -> MMHeatmapMonthGrid {
        let monthLastDate = calendar.lastDateOfMonth(year: year, month: month)
        let lastDay = calendar.component(.day, from: monthLastDate)
        let monthFirstDate = calendar.date(from: DateComponents(year: year, month: month, day: 1)) ?? monthLastDate
        let leadingEmptyDays = calendar.heatmapWeekdayIndex(for: monthFirstDate)
        let weekColumns = calendar.heatmapWeekColumnCount(year: year, month: month)

        let valuesByColumn = (0..<weekColumns).map { column in
            valuesForColumn(
                column,
                year: year,
                month: month,
                lastDay: lastDay,
                leadingEmptyDays: leadingEmptyDays,
                startDate: startDate,
                dataByElapsedDay: dataByElapsedDay,
                maxElapsedDay: maxElapsedDay,
                calendar: calendar
            )
        }

        return MMHeatmapMonthGrid(valuesByColumn: valuesByColumn)
    }

    private static func valuesForColumn(
        _ weekColumn: Int,
        year: Int,
        month: Int,
        lastDay: Int,
        leadingEmptyDays: Int,
        startDate: Date,
        dataByElapsedDay: [Int: Int],
        maxElapsedDay: Int?,
        calendar: Calendar
    ) -> [Int?] {
        var values = Array<Int?>(repeating: nil, count: 7)
        let firstCellIndex = weekColumn * 7

        for row in 0..<7 {
            let day = firstCellIndex + row - leadingEmptyDays + 1
            guard day >= 1 && day <= lastDay else {
                continue
            }

            guard let date = calendar.date(from: DateComponents(year: year, month: month, day: day)) else {
                continue
            }
            guard let elapsed = calendar.dateComponents([.day], from: startDate, to: date).day else {
                continue
            }

            if let maxElapsedDay, elapsed > maxElapsedDay {
                values[row] = nil
            } else {
                values[row] = dataByElapsedDay[elapsed] ?? 0
            }
        }

        return values
    }
}
