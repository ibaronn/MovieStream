import SwiftUI

struct ContentView: View {
    @State private var selectedTab: AppTab = .home
    @State private var showSplash = true
    @State private var showSettings = false
    @EnvironmentObject private var settingsVM: SettingsViewModel

    var body: some View {
        ZStack {
            Color.bgGradient.ignoresSafeArea()
            if showSplash { splash }
            else {
                VStack(spacing: 0) {
                    Group {
                        switch selectedTab {
                        case .home: HomeView()
                        case .browse: BrowseView()
                        case .search: SearchView()
                        case .favorites: FavoritesView()
                        }
                    }
                    AppTabBar(selectedTab: $selectedTab)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeOut(duration: 0.4)) { showSplash = false }
            }
        }
        .sheet(isPresented: $showSettings) { SettingsView() }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("OpenSettings"))) { _ in
            showSettings = true
        }
    }

    private var splash: some View {
        VStack(spacing: 16) {
            Image(systemName: "play.rectangle.fill").font(.system(size: 70)).foregroundColor(.accentGold).glow()
            Text("MOVE MK").font(.system(size: 34, weight: .bold, design: .rounded)).foregroundColor(.white)
            Text("أفلام ومسلسلات بجودة عالية").font(.headline).foregroundColor(.textSec)
        }
    }
}
