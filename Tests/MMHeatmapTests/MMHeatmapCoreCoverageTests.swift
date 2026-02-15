import XCTest
@testable import MMHeatmap

final class MMHeatmapCoreCoverageTests: XCTestCase {
    private let utc = TimeZone(secondsFromGMT: 0)!

    func testLegacyDateWrappersStillReturnValidComponents() {
        let source = Date(timeIntervalSince1970: 1_767_300_000)

        let truncated = source.truncate([.year, .month])
        let truncatedHms = source.truncateHms()
        let ymdhms = source.getYmdhms()

        XCTAssertNotNil(truncated)
        XCTAssertNotNil(truncatedHms)
        XCTAssertNotNil(ymdhms)
    }

    func testMMHeatmapDataYearInitializerUsesProvidedCalendar() {
        var buddhist = Calendar(identifier: .buddhist)
        buddhist.timeZone = utc

        let data = MMHeatmapData(year: 2569, month: 1, day: 1, value: 4, calendar: buddhist)
        let comps = buddhist.dateComponents([.year, .month, .day], from: data.date)

        XCTAssertEqual(comps.year, 2569)
        XCTAssertEqual(comps.month, 1)
        XCTAssertEqual(comps.day, 1)
    }

    func testMMHeatmapMonthGridWeekColumnValuesRespectLeadingEmptyDays() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 1
        calendar.timeZone = utc

        let startDate = Date(timeIntervalSince1970: 1_767_225_600)
        let grid = MMHeatmapMonthGrid.build(
            year: 2026,
            month: 1,
            startDate: startDate,
            dataByElapsedDay: [0: 7, 1: 8],
            maxElapsedDay: nil,
            calendar: calendar
        )

        let firstWeek = grid.valuesByColumn[0]
        XCTAssertEqual(firstWeek.count, 7)
        XCTAssertNil(firstWeek[0])
        XCTAssertNil(firstWeek[1])
        XCTAssertNil(firstWeek[2])
        XCTAssertNil(firstWeek[3])
        XCTAssertEqual(firstWeek[4], 7)
        XCTAssertEqual(firstWeek[5], 8)
        XCTAssertEqual(firstWeek[6], 0)
    }

    func testNormalizedHeatmapRatioHandlesZeroMaxValueAndBounds() {
        XCTAssertEqual(normalizedHeatmapRatio(value: 0, maxValue: 0), 0)
        XCTAssertEqual(normalizedHeatmapRatio(value: 5, maxValue: 0), 1)
        XCTAssertEqual(normalizedHeatmapRatio(value: -3, maxValue: 10), 0)
        XCTAssertEqual(normalizedHeatmapRatio(value: 5, maxValue: 10), 0.5)
        XCTAssertEqual(normalizedHeatmapRatio(value: 20, maxValue: 10), 1)
    }

    func testNormalizedWeekLabelsFallbacksWhenInputInvalid() {
        XCTAssertEqual(MMHeatmapView.normalizedWeekLabels(["Mon", "Tue"]), ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"])
        XCTAssertEqual(MMHeatmapView.normalizedWeekLabels(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]), ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"])
    }
}
