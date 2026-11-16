import SwiftUI
import SwiftData

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .onAppear {
                    NotificationManager.requestPermission()
                }
        }
        .modelContainer(for: Plant.self)
    }
}
