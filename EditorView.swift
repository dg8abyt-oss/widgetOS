import SwiftUI
import WidgetKit

struct EditorView: View {
    @AppStorage("widgetText", store: UserDefaults(suiteName: "group.com.yourname.canvas"))
    var widgetText: String = "Your Quote Here"
    
    @AppStorage("widgetColor", store: UserDefaults(suiteName: "group.com.yourname.canvas"))
    var widgetColor: String = "Blue"

    let colors = ["Blue", "Purple", "Pink", "Orange", "Green"]

    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemBackground).ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // --- LIVE PREVIEW ---
                    VStack(alignment: .leading) {
                        Text("PREVIEW").font(.caption2).bold().foregroundColor(.secondary)
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(LinearGradient(colors: [getBgColor(), .black], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 160, height: 160)
                            .overlay(
                                Text(widgetText)
                                    .font(.system(.headline, design: .rounded))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding()
                            )
                            .shadow(color: getBgColor().opacity(0.4), radius: 15, x: 0, y: 10)
                    }
                    .padding(.top)

                    // --- EDITOR CARD ---
                    VStack(spacing: 20) {
                        // Text Input
                        VStack(alignment: .leading) {
                            Label("Content", systemImage: "pencil.line")
                                .font(.subheadline).bold()
                            TextField("Type something...", text: $widgetText)
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(12)
                        }

                        // Color Picker
                        VStack(alignment: .leading) {
                            Label("Theme", systemImage: "paintpalette.fill")
                                .font(.subheadline).bold()
                            HStack {
                                ForEach(colors, id: \.self) { color in
                                    Circle()
                                        .fill(colorFromName(color))
                                        .frame(width: 35, height: 35)
                                        .overlay(Circle().stroke(Color.white, lineWidth: widgetColor == color ? 3 : 0))
                                        .onTapGesture { widgetColor = color }
                                }
                            }
                        }
                    }
                    .padding(25)
                    .background(RoundedRectangle(cornerRadius: 25).fill(Color(UIColor.secondarySystemBackground).opacity(0.5)))
                    
                    Spacer()

                    // --- ACTION BUTTON ---
                    Button(action: { WidgetCenter.shared.reloadAllTimelines() }) {
                        HStack {
                            Text("Sync to Widget")
                            Image(systemName: "arrow.triangle.2.circlepath")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(15)
                    }
                }
                .padding()
            }
            .navigationTitle("Canvas")
        }
    }

    func getBgColor() -> Color { colorFromName(widgetColor) }
    
    func colorFromName(_ name: String) -> Color {
        switch name {
            case "Purple": return .purple
            case "Pink": return .pink
            case "Orange": return .orange
            case "Green": return .green
            default: return .blue
        }
    }
}
