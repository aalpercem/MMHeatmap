import XCTest
@testable import MMHeatmap

final class MMHeatmapViewLocaleTests: XCTestCase {
    private let utc = TimeZone(secondsFromGMT: 0)!

    func testMMHeatmapViewKeepsCalendarWeekSemanticsWhenLocaleProvided() {
        var calendar = Calendar(identifier: .buddhist)
        calendar.firstWeekday = 1
        calendar.timeZone = utc

        let start = Date(timeIntervalSince1970: 1_767_225_600) // 2026-01-01 UTC
        let end = Date(timeIntervalSince1970: 1_798_761_600) // 2026-12-31 UTC
        let data = [MMHeatmapData(date: start, value: 3, calendar: calendar)]

        let view = MMHeatmapView(
            start: start,
            end: end,
            data: data,
            calendar: calendar,
            locale: Locale(identifier: "tr_TR"),
            timeZone: utc
        )

        XCTAssertEqual(view.calendar.firstWeekday, 1)
        XCTAssertEqual(view.sundayLabelIndex, 0)
        XCTAssertEqual(view.saturdayLabelIndex, 6)
    }

    func testMMHeatmapViewMonthLabelFollowsLocale() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        calendar.timeZone = utc

        let start = Date(timeIntervalSince1970: 1_767_225_600) // 2026-01-01 UTC
        let end = Date(timeIntervalSince1970: 1_798_761_600) // 2026-12-31 UTC
        let data = [MMHeatmapData(date: start, value: 1, calendar: calendar)]

        let trView = MMHeatmapView(
            start: start,
            end: end,
            data: data,
            calendar: calendar,
            locale: Locale(identifier: "tr_TR"),
            timeZone: utc
        )

        let enView = MMHeatmapView(
            start: start,
            end: end,
            data: data,
            calendar: calendar,
            locale: Locale(identifier: "en_US"),
            timeZone: utc
        )

        XCTAssertTrue(trView.getMMLabel(MM: 1).lowercased().hasPrefix("oca"))
        XCTAssertTrue(enView.getMMLabel(MM: 1).hasPrefix("Jan"))
    }

    func testMMHeatmapViewWeekIndicesFollowCalendarFirstWeekday() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        calendar.timeZone = utc

        let start = Date(timeIntervalSince1970: 1_767_225_600) // 2026-01-01 UTC
        let end = Date(timeIntervalSince1970: 1_798_761_600) // 2026-12-31 UTC
        let data = [MMHeatmapData(date: start, value: 1, calendar: calendar)]

        let view = MMHeatmapView(
            start: start,
            end: end,
            data: data,
            calendar: calendar,
            locale: Locale(identifier: "en_US"),
            timeZone: utc
        )

        XCTAssertEqual(view.sundayLabelIndex, 6)
        XCTAssertEqual(view.saturdayLabelIndex, 5)
    }
}
