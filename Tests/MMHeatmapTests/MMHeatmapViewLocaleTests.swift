import XCTest
@testable import MMHeatmap

final class MMHeatmapViewLocaleTests: XCTestCase {
    func testMMHeatmapViewUsesSystemWeekSemantics() {
        let systemCalendar = Calendar.autoupdatingCurrent

        let start = Date(timeIntervalSince1970: 1_767_225_600) // 2026-01-01 UTC
        let end = Date(timeIntervalSince1970: 1_798_761_600) // 2026-12-31 UTC
        let data = [MMHeatmapData(date: start, value: 3)]

        let view = MMHeatmapView(
            start: start,
            end: end,
            data: data,
            labelLocale: Locale(identifier: "tr_TR")
        )

        XCTAssertEqual(view.calendar.firstWeekday, systemCalendar.firstWeekday)
        XCTAssertEqual(view.sundayLabelIndex, MMHeatmapView.weekdayIndex(weekday: 1, firstWeekday: systemCalendar.firstWeekday))
        XCTAssertEqual(view.saturdayLabelIndex, MMHeatmapView.weekdayIndex(weekday: 7, firstWeekday: systemCalendar.firstWeekday))
    }

    func testMMHeatmapViewMonthLabelFollowsLocale() {
        let start = Date(timeIntervalSince1970: 1_767_225_600) // 2026-01-01 UTC
        let end = Date(timeIntervalSince1970: 1_798_761_600) // 2026-12-31 UTC
        let data = [MMHeatmapData(date: start, value: 1)]

        let trView = MMHeatmapView(
            start: start,
            end: end,
            data: data,
            labelLocale: Locale(identifier: "tr_TR")
        )

        let enView = MMHeatmapView(
            start: start,
            end: end,
            data: data,
            labelLocale: Locale(identifier: "en_US")
        )

        XCTAssertTrue(trView.getMMLabel(MM: 1).lowercased().hasPrefix("oca"))
        XCTAssertTrue(enView.getMMLabel(MM: 1).hasPrefix("Jan"))
    }

    func testMMHeatmapViewWeekIndicesFollowSystemFirstWeekday() {
        let systemCalendar = Calendar.autoupdatingCurrent
        let start = Date(timeIntervalSince1970: 1_767_225_600) // 2026-01-01 UTC
        let end = Date(timeIntervalSince1970: 1_798_761_600) // 2026-12-31 UTC
        let data = [MMHeatmapData(date: start, value: 1)]

        let view = MMHeatmapView(
            start: start,
            end: end,
            data: data,
            labelLocale: Locale(identifier: "en_US")
        )

        XCTAssertEqual(view.sundayLabelIndex, MMHeatmapView.weekdayIndex(weekday: 1, firstWeekday: systemCalendar.firstWeekday))
        XCTAssertEqual(view.saturdayLabelIndex, MMHeatmapView.weekdayIndex(weekday: 7, firstWeekday: systemCalendar.firstWeekday))
    }
}
