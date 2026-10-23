import SwiftUI
import SwiftData

@main
struct CampusMateApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Subject.self, ClassSlot.self, Building.self, Assignment.self])
        }
    }
}
