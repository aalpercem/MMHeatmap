import SwiftUI
import UIKit

private struct MMHeatmapPreviewPlayground: View {
    @State private var selectedLocale: String = "tr_TR"
    @State private var isScroll: Bool = true
    @State private var clippedWithEndDate: Bool = true

    private let localeOptions = ["tr_TR", "en_US", "de_DE", "ar_SA"]

    private var previewCalendar: Calendar {
        var calendar = Calendar.autoupdatingCurrent
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
            return MMHeatmapData(date: date, value: value)
        }
    }

    private var style: MMHeatmapStyle {
        MMHeatmapStyle(
            baseCellColor: UIColor.systemIndigo,
            week: MMHeatmapStyle.localizedWeekSymbols(
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
                    labelLocale: previewLocale
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
        MMHeatmapStyle.localizedWeekSymbols(locale: locale, style: .full)
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

#Preview {
    MMHeatmapPreviewPlayground()
}
