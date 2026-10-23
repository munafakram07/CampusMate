import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context

    var body: some View {
        TabView {
            TimetableView()
                .tabItem { Label("Timetable", systemImage: "calendar") }
        }
        .task { SeedData.seedIfNeeded(context: context) }
    }
}
