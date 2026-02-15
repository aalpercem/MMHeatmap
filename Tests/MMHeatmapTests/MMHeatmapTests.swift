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
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        let symbols = MMHeatmapStyle.localizedWeekSymbols(
            calendar: calendar,
            locale: Locale(identifier: "en_US"),
            style: .short
        )
        XCTAssertEqual(symbols.first, "Mon")
        XCTAssertEqual(symbols.last, "Sun")
    }
}
