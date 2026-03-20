import WidgetKit
import SwiftUI

struct FarmData {
    let totalAnimals: String
    let pregnant: String
    let activeTreatments: String
    let overdueVax: String
    let nextEvent: String
    let lastUpdated: String
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> FarmEntry {
        FarmEntry(date: Date(), data: FarmData(
            totalAnimals: "24", pregnant: "4", activeTreatments: "3",
            overdueVax: "5",
            nextEvent: "FMD Vaccination – C-001",
            lastUpdated: "12:30:00"
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
        return FarmData(
            totalAnimals: defaults?.string(forKey: "total_animals") ?? "0",
            pregnant: defaults?.string(forKey: "pregnant") ?? "0",
            activeTreatments: defaults?.string(forKey: "active_treatments") ?? "0",
            overdueVax: defaults?.string(forKey: "overdue_vax") ?? "0",
            nextEvent: defaults?.string(forKey: "next_event") ?? "No upcoming events",
            lastUpdated: defaults?.string(forKey: "last_updated") ?? ""
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
        VStack(alignment: .leading, spacing: 8) {
            // ── Header: logo + brand + live dot ──
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

            // ── Stats 2×2 Grid ──
            HStack(spacing: 6) {
                StatTile(emoji: "🐄", value: entry.data.totalAnimals, label: "Total", accent: Color(red: 0.18, green: 0.49, blue: 0.20))
                StatTile(emoji: "🤰", value: entry.data.pregnant, label: "Pregnant", accent: .blue)
            }
            HStack(spacing: 6) {
                StatTile(emoji: "🩺", value: entry.data.activeTreatments, label: "Treating", accent: .orange)
                StatTile(emoji: "💉", value: entry.data.overdueVax, label: "Vax Due", accent: .red)
            }

            // ── Next Event Banner ──
            HStack(spacing: 6) {
                Text("📅").font(.system(size: 18))
                Text(entry.data.nextEvent)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color(red: 0.11, green: 0.37, blue: 0.13))
                    .lineLimit(1)
                Spacer()
                Text("›")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(red: 0.18, green: 0.49, blue: 0.20))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                LinearGradient(
                    colors: [Color(red: 0.91, green: 0.96, blue: 0.91),
                             Color(red: 0.78, green: 0.90, blue: 0.78)],
                    startPoint: .leading, endPoint: .trailing
                )
            )
            .cornerRadius(10)
        }
        .padding(10)
        .background(
            LinearGradient(
                colors: [Color.white, Color(red: 0.95, green: 0.97, blue: 0.91)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        )
    }
}

// ── Stat Tile ──

struct StatTile: View {
    let emoji: String
    let value: String
    let label: String
    let accent: Color

    var body: some View {
        HStack(spacing: 6) {
            Text(emoji).font(.system(size: 26))
            VStack(alignment: .leading, spacing: 1) {
                Text(value)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(accent)
                Text(label)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(accent.opacity(0.7))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(accent.opacity(0.35), lineWidth: 1.5)
        )
        .cornerRadius(12)
    }
}
