# MMHeatmap
<img width="375" alt="HeatmapSample" src="https://user-images.githubusercontent.com/72431055/115141826-5572b580-a079-11eb-822b-4e05cf9273ca.png">

Heatmap style calendar made in SwiftUI.
## Installation
1. Use **"Swift Package Manager"**:  
`File -> Swift Packages -> Add Package Dependency`  
  
2. Paste URL:  
`https://github.com/s-n-1-0/MMHeatmap.git`


## MMHeatmapView
Displays a calendar from "start" to "end".
```swift
//"import  MMHeatmap" is required

var calendar = Calendar.autoupdatingCurrent
let start = calendar.date(from: DateComponents(year:2021,month: 12,day: 20))!
let end = calendar.date(from: DateComponents(year:2022,month: 4,day: 3))! // or nil = now
let data = [
    MMHeatmapData(year: 2022, month: 3, day: 10, value: 5, calendar: calendar),
    MMHeatmapData(year: 2022, month: 4, day:1, value: 10, calendar: calendar)
]

let locale = Locale(identifier: "tr_TR")
let week = MMHeatmapStyle.localizedWeekSymbols(
    calendar: calendar,
    locale: locale,
    style: .short
)

//view
HStack{
    MMHeatmapView(
        start: start,
        end: end,
        data: data,
        style: MMHeatmapStyle(
            baseCellColor: UIColor.systemIndigo,
            week: week,
            isScroll: true
        ),
        calendar: calendar,
        locale: locale,
        timeZone: .autoupdatingCurrent
    )
    Spacer()
}
```
*The variable "style:" is optional.  
<br>
## MMHeatmapViewData
Calendar cell data.  
Please not duplicate dates in MMHeatmapViewData.
#### **(year,month,day) or date**

```swift
public init(date _date:Date,value:Int,calendar: Calendar = Calendar(identifier: .gregorian))
```
```swift
public init(year:Int,month:Int,day:Int,value:Int,calendar: Calendar = Calendar(identifier: .gregorian))
```

#### **value:**
Specifies the color strength of the cell.  
Specify a value greater than or equal to 0.  
*If you want to set Color.clear, use "nil".

## MMHeatmapStyle
| Variable  |Description                                                                |     | 
| ------------- | ------------------------------------------------------------------------------ | --- | 
| baseCellColor | Maximum color                                                                  |     | 
| minCellColor  | Color when value is 0                                                          |     | 
| week          | Notation of the day of the week                                                |     | 
| dateMMFormat  | Months format<br>Example: 4<br>"M" = 4<br>"MM" = 04<br>"MMM" = en: Apr , ja: 4月 |     |
|clippedWithEndDate|**true** : If you want to display cells up to end parameter.<br>**false** : if you want to display cells until the end of the month in the last month.|
|isScroll|scrolling.<br>*Disabled for iOS13|

### Week labels

`week` should contain exactly 7 items and should be ordered from `calendar.firstWeekday`.

Use `MMHeatmapStyle.localizedWeekSymbols(...)` to generate locale-aware labels in the correct order:

```swift
let week = MMHeatmapStyle.localizedWeekSymbols(
    calendar: calendar,
    locale: locale,
    style: .short // .veryShort / .short / .full
)
```

If an invalid `week` array is passed, MMHeatmap falls back to `Sun...Sat` labels.

`MMHeatmapView` uses the provided `calendar` for date math and week layout semantics.

`locale` is used for textual formatting (month labels), and `week` labels should be ordered from `calendar.firstWeekday` to keep labels aligned with heatmap rows.

### Behavior notes

- `calendar` controls grid/date semantics (including `firstWeekday`).
- `locale` controls text formatting (for example month names).
- `maxValue == 0` is handled safely during rendering.

---

### Use in Widget Extension

Read this. https://github.com/s-n-1-0/MMHeatmap/issues/2

### PR / Issues
Please PR or Issues if you have any questions.
