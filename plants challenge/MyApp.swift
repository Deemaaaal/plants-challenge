import SwiftUI

@main struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            //in the app
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
//whole im writing
#Preview {
    ContentView()
        .preferredColorScheme( .dark)
}


