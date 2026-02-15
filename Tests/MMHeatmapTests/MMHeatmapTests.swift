import XCTest
import MMHeatmap
final class MMHeatmapTests: XCTestCase {
    func testHeatmapStyleWeekCount() {
        XCTAssertEqual(MMHeatmapStyle(baseCellColor: UIColor.black).week.count,7)
    }
    func testHeatmapStyleAttributeAccess(){
        XCTAssertEqual(MMHeatmapStyle(baseCellColor: UIColor.black).minCellColor,UIColor.secondarySystemBackground)
        XCTAssertEqual(MMHeatmapStyle(baseCellColor: UIColor.black).baseCellColor, UIColor.black)
    }
    func testHeatmapDataAttributeAccess(){
        let d = MMHeatmapElapsedData(elapsedDay: 0, value: 10)
        XCTAssertEqual(d.elapsedDay,0)
        XCTAssertEqual(d.value,10)
    }

    func testLocalizedWeekSymbolsStartsFromCalendarFirstWeekday() {
        let calendar = Calendar.autoupdatingCurrent
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = Locale(identifier: "en_US")
        let raw = formatter.shortStandaloneWeekdaySymbols ?? []
        let startIndex = max(min(calendar.firstWeekday - 1, 6), 0)
        let expected = Array(raw[startIndex...]) + Array(raw[..<startIndex])

        let symbols = MMHeatmapStyle.localizedWeekSymbols(
            locale: Locale(identifier: "en_US"),
            style: .short
        )
        XCTAssertEqual(symbols, expected)
    }
}
