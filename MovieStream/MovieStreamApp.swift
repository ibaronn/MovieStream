import SwiftUI

@main
struct MovieStreamApp: App {
    @StateObject private var favoritesVM = FavoritesViewModel()
    @Environment(\.colorScheme) private var colorScheme

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(favoritesVM)
                .preferredColorScheme(.dark)
                .environment(\.layoutDirection, .rightToLeft)
        }
    }
}
