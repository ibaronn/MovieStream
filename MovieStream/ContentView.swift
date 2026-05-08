import SwiftUI

struct ContentView: View {
    @State private var selectedTab: AppTab = .home
    @State private var showSplash = true
    @Namespace private var animation

    var body: some View {
        ZStack {
            Color.darkBackground.ignoresSafeArea()

            if showSplash {
                splashScreen
            } else {
                VStack(spacing: 0) {
                    mainContent
                    AnimatedTabBar(selectedTab: $selectedTab)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut(duration: 0.6)) {
                    showSplash = false
                }
            }
        }
    }

    private var splashScreen: some View {
        VStack(spacing: 20) {
            Image(systemName: "play.rectangle.fill")
                .font(.system(size: 80))
                .foregroundColor(.accentGold)
                .glow(color: .accentGold, radius: 25)
            Text("MovieStream")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            Text("أفلام ومسلسلات بجودة عالية")
                .font(.headline)
                .foregroundColor(.textSecondary)
        }
        .transition(.opacity)
    }

    private var mainContent: some View {
        Group {
            switch selectedTab {
            case .home:
                HomeView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .opacity
                    ))
            case .browse:
                BrowseView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .opacity
                    ))
            case .search:
                SearchView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .opacity
                    ))
            case .favorites:
                FavoritesView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .opacity
                    ))
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: selectedTab)
    }
}
