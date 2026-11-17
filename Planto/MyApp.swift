import SwiftUI
import SwiftData

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            StartJourneyView()
                .preferredColorScheme(.dark)
                .onAppear {
                    NotificationManager.requestPermission()// asking for permision
                }
        }
        .modelContainer(for: Plant.self)//where i saves the plants 
    }
}
