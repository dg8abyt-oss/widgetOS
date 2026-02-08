import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), text: "Canvas", color: .blue)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        completion(fetchData())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        completion(Timeline(entries: [fetchData()], policy: .atEnd))
    }

    func fetchData() -> SimpleEntry {
        let prefs = UserDefaults(suiteName: "group.com.yourname.canvas")
        let text = prefs?.string(forKey: "widgetText") ?? "Tap to Edit"
        let colorName = prefs?.string(forKey: "widgetColor") ?? "Blue"
        return SimpleEntry(date: Date(), text: text, colorName: colorName)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let text: String
    var colorName: String = "Blue"
    
    var color: Color {
        switch colorName {
            case "Purple": return .purple
            case "Pink": return .pink
            case "Orange": return .orange
            case "Green": return .green
            default: return .blue
        }
    }
}

struct CanvasWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        ZStack {
            if family == .accessoryRectangular {
                // Lock Screen
                VStack(alignment: .leading) {
                    Text("CANVAS").font(.caption2).bold()
                    Text(entry.text).font(.system(.body, design: .rounded))
                }
            } else {
                // Home Screen
                ContainerRelativeShape()
                    .fill(LinearGradient(colors: [entry.color, .black.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing))
                
                Text(entry.text)
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.white)
                    .padding()
            }
        }
        .containerBackground(for: .widget) { entry.color.opacity(0.2) }
    }
}

@main
struct CanvasWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "CanvasWidget", provider: Provider()) { entry in
            CanvasWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall, .accessoryRectangular])
    }
}
