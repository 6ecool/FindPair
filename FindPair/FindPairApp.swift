import SwiftUI

@main
struct FindPairApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
