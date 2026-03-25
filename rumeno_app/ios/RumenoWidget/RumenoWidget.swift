import WidgetKit
import SwiftUI

struct FarmData {
    let activeTreatments: String
    let milkToday: String
    let kidsCount: String
    let pregnant: String
    let nextEvent: String
    let lastUpdated: String
    let alerts: [String]
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> FarmEntry {
        FarmEntry(date: Date(), data: FarmData(
            activeTreatments: "3", milkToday: "230", kidsCount: "4",
            pregnant: "4",
            nextEvent: "PPR Vaccination – G-001",
            lastUpdated: "12:30:00",
            alerts: ["💉 BQ Due – C-001", "💉 PPR Due – G-002", "🩺 Foot Rot – C-003"]
        ))
    }

    func getSnapshot(in context: Context, completion: @escaping (FarmEntry) -> Void) {
        completion(FarmEntry(date: Date(), data: loadData()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<FarmEntry>) -> Void) {
        let entry = FarmEntry(date: Date(), data: loadData())
        let nextUpdate = Calendar.current.date(byAdding: .second, value: 2, to: Date())!
        completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
    }

    private func loadData() -> FarmData {
        let defaults = UserDefaults(suiteName: "group.com.rumeno.rumenoApp")
        let alertCount = Int(defaults?.string(forKey: "alert_count") ?? "0") ?? 0
        var alerts: [String] = []
        for i in 0..<min(alertCount, 10) {
            if let alert = defaults?.string(forKey: "alert_\(i)"), !alert.isEmpty {
                alerts.append(alert)
            }
        }
        return FarmData(
            activeTreatments: defaults?.string(forKey: "active_treatments") ?? "0",
            milkToday: defaults?.string(forKey: "milk_today") ?? "0",
            kidsCount: defaults?.string(forKey: "kids_count") ?? "0",
            pregnant: defaults?.string(forKey: "pregnant") ?? "0",
            nextEvent: defaults?.string(forKey: "next_event") ?? "No upcoming events",
            lastUpdated: defaults?.string(forKey: "last_updated") ?? "",
            alerts: alerts
        )
    }
}

struct FarmEntry: TimelineEntry {
    let date: Date
    let data: FarmData
}

// ─── Modern Widget View ───────────────────────

struct RumenoWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // ── Header: logo + brand + notification + live dot ──
            HStack(spacing: 8) {
                Image("Rumeno_logo-rb")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26, height: 26)
                    .clipShape(Circle())

                Text("Rumeno Farm")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)

                Spacer()

                Text("🔔")
                    .font(.system(size: 16))

                Circle()
                    .fill(Color.green)
                    .frame(width: 7, height: 7)
                Text(entry.data.lastUpdated)
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(Color.white.opacity(0.8))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(
                LinearGradient(
                    colors: [Color(red: 0.18, green: 0.49, blue: 0.20),
                             Color(red: 0.26, green: 0.63, blue: 0.28)],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                )
            )
            .cornerRadius(12)

            // ── Stats: Single Row with 4 items ──
            HStack(spacing: 4) {
                CompactStatTile(emoji: "🩺", value: entry.data.activeTreatments, label: "Ongoing\nTreatment", accent: .orange)
                CompactStatTile(emoji: "🥛", value: entry.data.milkToday, label: "Today\nMilk", accent: Color(red: 0.18, green: 0.49, blue: 0.20))
                CompactStatTile(emoji: "🐐", value: entry.data.kidsCount, label: "Kids\n0-1m", accent: Color(red: 0.0, green: 0.47, blue: 0.42))
                CompactStatTile(emoji: "🤰", value: entry.data.pregnant, label: "Pregnant", accent: .blue)
            }

            // ── PPR Vaccination Event Banner ──
            HStack(spacing: 6) {
                Text("📅").font(.system(size: 14))
                Text(entry.data.nextEvent)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Color(red: 0.11, green: 0.37, blue: 0.13))
                    .lineLimit(1)
                Spacer()
                Text("›")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(red: 0.18, green: 0.49, blue: 0.20))
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(
                LinearGradient(
                    colors: [Color(red: 0.91, green: 0.96, blue: 0.91),
                             Color(red: 0.78, green: 0.90, blue: 0.78)],
                    startPoint: .leading, endPoint: .trailing
                )
            )
            .cornerRadius(10)

            // ── Vaccination & Health Alerts ──
            if !entry.data.alerts.isEmpty {
                Text("Vaccination & Health Alerts")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(red: 0.18, green: 0.49, blue: 0.20))
                    .padding(.top, 2)

                VStack(alignment: .leading, spacing: 2) {
                    ForEach(entry.data.alerts.prefix(10), id: \.self) { alert in
                        Text(alert)
                            .font(.system(size: 10))
                            .foregroundColor(Color(red: 0.22, green: 0.28, blue: 0.31))
                            .lineLimit(1)
                    }
                }
            }
        }
        .padding(8)
        .background(Color.clear)
    }
}

// ── Compact Stat Tile (for 4-in-a-row) ──

struct CompactStatTile: View {
    let emoji: String
    let value: String
    let label: String
    let accent: Color

    var body: some View {
        VStack(spacing: 2) {
            Text(emoji).font(.system(size: 16))
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(accent)
            Text(label)
                .font(.system(size: 8, weight: .bold))
                .foregroundColor(accent.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(6)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(accent.opacity(0.35), lineWidth: 1.5)
        )
        .cornerRadius(12)
    }
}
