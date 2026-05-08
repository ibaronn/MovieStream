import SwiftUI

@main
struct MoveMKApp: App {
    @StateObject private var favoritesVM = FavoritesViewModel()
    @StateObject private var settingsVM = SettingsViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(favoritesVM)
                .environmentObject(settingsVM)
                .preferredColorScheme(.dark)
                .environment(\.layoutDirection, .rightToLeft)
        }
    }
}
