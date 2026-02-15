import SwiftUI

private struct MMHeatmapPreviewPlayground: View {
    enum CalendarOption: String, CaseIterable, Identifiable {
        case device
        case gregorian
        case iso8601
        case buddhist

        var id: String { rawValue }

        var title: String {
            switch self {
            case .device:
                return "Device"
            case .gregorian:
                return "Gregorian"
            case .iso8601:
                return "ISO8601"
            case .buddhist:
                return "Buddhist"
            }
        }
    }

    @State private var selectedCalendar: CalendarOption = .device
    @State private var selectedLocale: String = "tr_TR"
    @State private var isScroll: Bool = true
    @State private var clippedWithEndDate: Bool = true

    private let localeOptions = ["tr_TR", "en_US", "de_DE", "ar_SA"]

    private var baseCalendar: Calendar {
        switch selectedCalendar {
        case .device:
            return Calendar.autoupdatingCurrent
        case .gregorian:
            return Calendar(identifier: .gregorian)
        case .iso8601:
            return Calendar(identifier: .iso8601)
        case .buddhist:
            return Calendar(identifier: .buddhist)
        }
    }

    private var previewCalendar: Calendar {
        var calendar = baseCalendar
        calendar.timeZone = .current
        return calendar
    }

    private var previewLocale: Locale {
        Locale(identifier: selectedLocale)
    }

    private var startDate: Date {
        Date(timeIntervalSince1970: 1_767_225_600) // 2026-01-01 UTC
    }

    private var endDate: Date {
        Date(timeIntervalSince1970: 1_798_761_600) // 2026-12-31 UTC
    }

    private var previewData: [MMHeatmapData] {
        let dayCount = (previewCalendar.dateComponents([.day], from: startDate, to: endDate).day ?? 0) + 1
        return (0..<max(dayCount, 1)).compactMap { offset in
            guard let date = previewCalendar.date(byAdding: .day, value: offset, to: startDate) else {
                return nil
            }
            let value = ((offset * 7) % 12)
            return MMHeatmapData(date: date, value: value, calendar: previewCalendar)
        }
    }

    private var style: MMHeatmapStyle {
        MMHeatmapStyle(
            baseCellColor: UIColor.systemIndigo,
            week: MMHeatmapStyle.localizedWeekSymbols(
                calendar: previewCalendar,
                locale: previewLocale,
                style: .short
            ),
            clippedWithEndDate: clippedWithEndDate,
            isScroll: isScroll
        )
    }

    private var currentCalendarDescription: String {
        "\(previewCalendar.identifier) / firstWeekday=\(previewCalendar.firstWeekday) / locale=\(selectedLocale)"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("MMHeatmap Preview Playground")
                    .font(.headline)

                Picker("Calendar", selection: $selectedCalendar) {
                    ForEach(CalendarOption.allCases) { option in
                        Text(option.title).tag(option)
                    }
                }
                .pickerStyle(.segmented)

                Picker("Locale", selection: $selectedLocale) {
                    ForEach(localeOptions, id: \.self) { locale in
                        Text(locale).tag(locale)
                    }
                }
                .pickerStyle(.segmented)

                Text("Effective calendar: \(currentCalendarDescription)")
                    .font(.footnote)
                    .foregroundColor(.secondary)

                Toggle("Scroll Enabled", isOn: $isScroll)
                Toggle("Clip With End Date", isOn: $clippedWithEndDate)

                MMHeatmapView(
                    start: startDate,
                    end: endDate,
                    data: previewData,
                    style: style,
                    layout: MMHeatmapLayout(cellSize: 14),
                    calendar: previewCalendar,
                    locale: previewLocale,
                    timeZone: .current
                )
                .padding(12)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)

#if DEBUG
                MMHeatmapDebugWeekLegend(calendar: previewCalendar, locale: previewLocale)
#endif
            }
            .padding()
        }
    }
}

#if DEBUG
private struct MMHeatmapDebugWeekLegend: View {
    let calendar: Calendar
    let locale: Locale

    private var fullSymbols: [String] {
        MMHeatmapStyle.localizedWeekSymbols(calendar: calendar, locale: locale, style: .full)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Debug - Week Row Mapping")
                .font(.subheadline)
                .bold()
            ForEach(Array(fullSymbols.enumerated()), id: \.offset) { item in
                Text("row \(item.offset): \(item.element)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(10)
        .background(Color(UIColor.tertiarySystemBackground))
        .cornerRadius(10)
    }
}
#endif

private struct MMHeatmapFixedCalendarPreview: View {
    let title: String
    let localeIdentifier: String
    let calendarIdentifier: Calendar.Identifier

    private var previewLocale: Locale {
        Locale(identifier: localeIdentifier)
    }

    private var previewCalendar: Calendar {
        var calendar = Calendar(identifier: calendarIdentifier)
        calendar.locale = previewLocale
        calendar.timeZone = .current
        return calendar
    }

    private var startDate: Date {
        Date(timeIntervalSince1970: 1_767_225_600) // 2026-01-01 UTC
    }

    private var endDate: Date {
        Date(timeIntervalSince1970: 1_798_761_600) // 2026-12-31 UTC
    }

    private var previewData: [MMHeatmapData] {
        let dayCount = (previewCalendar.dateComponents([.day], from: startDate, to: endDate).day ?? 0) + 1
        return (0..<max(dayCount, 1)).compactMap { offset in
            guard let date = previewCalendar.date(byAdding: .day, value: offset, to: startDate) else {
                return nil
            }
            let value = ((offset * 5) % 12)
            return MMHeatmapData(date: date, value: value, calendar: previewCalendar)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
            Text("calendar=\(String(describing: previewCalendar.identifier)), locale=\(localeIdentifier), firstWeekday=\(previewCalendar.firstWeekday)")
                .font(.footnote)
                .foregroundColor(.secondary)
            MMHeatmapView(
                start: startDate,
                end: endDate,
                data: previewData,
                style: MMHeatmapStyle(
                    baseCellColor: UIColor.systemTeal,
                    week: MMHeatmapStyle.localizedWeekSymbols(
                        calendar: previewCalendar,
                        locale: previewLocale,
                        style: .short
                    ),
                    clippedWithEndDate: true,
                    isScroll: true
                ),
                layout: MMHeatmapLayout(cellSize: 14),
                calendar: previewCalendar,
                locale: previewLocale,
                timeZone: .current
            )
            .padding(10)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
        }
        .padding()
    }
}

#Preview {
    MMHeatmapPreviewPlayground()
}
