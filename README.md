# MMHeatmap

<img width="375" alt="HeatmapSample" src="https://user-images.githubusercontent.com/72431055/115141826-5572b580-a079-11eb-822b-4e05cf9273ca.png">

SwiftUI heatmap calendar view.

## Installation

Use Swift Package Manager:

1. In Xcode: `File -> Add Package Dependencies...`
2. Enter package URL:

`https://github.com/s-n-1-0/MMHeatmap.git`

If you use a fork, replace the URL with your fork URL.

## Quick Start

```swift
import MMHeatmap

let systemCalendar = Calendar.autoupdatingCurrent
let start = systemCalendar.date(from: DateComponents(year: 2026, month: 1, day: 1))!
let end = systemCalendar.date(from: DateComponents(year: 2026, month: 12, day: 31))!

let data: [MMHeatmapData] = [
    MMHeatmapData(year: 2026, month: 1, day: 1, value: 4),
    MMHeatmapData(year: 2026, month: 1, day: 2, value: 8)
]

let labelLocale = Locale(identifier: "tr_TR")
let weekLabels = MMHeatmapStyle.localizedWeekSymbols(
    locale: labelLocale,
    style: .short
)

let style = MMHeatmapStyle(
    baseCellColor: .systemIndigo,
    week: weekLabels,
    isScroll: true
)

MMHeatmapView(
    start: start,
    end: end,
    data: data,
    style: style,
    labelLocale: labelLocale
)
```

## Behavior Policy

- Grid/date semantics always use the system calendar (`Calendar.autoupdatingCurrent`).
- Week start (`firstWeekday`) always comes from the system/region.
- `labelLocale` only affects text formatting (month labels).
- `week` labels must match system week order.

This separation prevents locale-related week-start mismatches.

## API Reference

### MMHeatmapView

Displays a calendar heatmap from `start` to `end`.

```swift
public init(
    start: Date,
    end: Date? = nil,
    data: [MMHeatmapData],
    style: MMHeatmapStyle = MMHeatmapStyle(baseCellColor: .label),
    layout: MMHeatmapLayout = MMHeatmapLayout(),
    labelLocale: Locale = .autoupdatingCurrent
)
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `start` | `Date` | required | First displayed month anchor. |
| `end` | `Date?` | `nil` | End date; `nil` means current date. |
| `data` | `[MMHeatmapData]` | required | Heatmap values by date. |
| `style` | `MMHeatmapStyle` | default style | Colors, week labels, month format, scroll behavior. |
| `layout` | `MMHeatmapLayout` | default layout | Cell size and layout metrics. |
| `labelLocale` | `Locale` | `.autoupdatingCurrent` | Text locale for month label formatting. |

### MMHeatmapData

Cell input model. Do not provide duplicate dates.

```swift
public init(date: Date, value: Int)
public init(year: Int, month: Int, day: Int, value: Int)
```

| Field | Type | Notes |
| --- | --- | --- |
| `value` | `Int` | Color intensity. Use `>= 0` values. |

### MMHeatmapStyle

```swift
public init(
    baseCellColor: UIColor,
    minCellColor: UIColor = .secondarySystemBackground,
    week: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
    dateMMFormat: String = "MMM",
    clippedWithEndDate: Bool = true,
    isScroll: Bool = true
)
```

| Property | Type | Description |
| --- | --- | --- |
| `baseCellColor` | `UIColor` | Maximum color. |
| `minCellColor` | `UIColor` | Cell color when value is `0`. |
| `week` | `[String]` | 7 weekday labels, ordered by system `firstWeekday`. |
| `dateMMFormat` | `String` | Month text format (`M`, `MM`, `MMM`, ...). |
| `clippedWithEndDate` | `Bool` | If `true`, clip rendering at `end`; otherwise fill through month end. |
| `isScroll` | `Bool` | Horizontal scrolling behavior (iOS 13 fallback is non-scroll). |

### MMHeatmapStyle.localizedWeekSymbols

Generates locale-aware weekday labels already rotated to the system week start.

```swift
public static func localizedWeekSymbols(
    locale: Locale = .autoupdatingCurrent,
    style: MMHeatmapWeekdaySymbolStyle = .short
) -> [String]
```

`MMHeatmapWeekdaySymbolStyle` options:

- `.veryShort`
- `.short`
- `.full`

## Notes

- If `week` does not contain exactly 7 labels, MMHeatmap falls back to `Sun...Sat`.
- Rendering handles `maxValue == 0` safely.

## Breaking Changes (Current Fork)

- `MMHeatmapView` no longer accepts `calendar`, `locale`, or `timeZone`.
- `MMHeatmapView` now accepts `labelLocale`.
- `MMHeatmapData` initializers no longer accept `calendar`.
- `MMHeatmapStyle.localizedWeekSymbols` no longer accepts `calendar`.

## Widget Extension

See: https://github.com/s-n-1-0/MMHeatmap/issues/2

## PR / Issues

PRs and issues are welcome.
