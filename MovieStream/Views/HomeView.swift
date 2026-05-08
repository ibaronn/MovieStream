import SwiftUI

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()
    @State private var selected: Movie?
    @State private var showSettings = false
    @EnvironmentObject private var settingsVM: SettingsViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                header
                if vm.isLoading { loading }
                else if case .notConfigured = vm.errorCase { configNeeded }
                else if vm.featuredMovie == nil { empty }
                else {
                    if let f = vm.featuredMovie { featured(f) }
                    genres
                    trending
                    recent
                }
            }.padding(.bottom, 8)
        }
        .safeAreaInset(edge: .top) { Color.clear.frame(height: 0) }
        .background(Color.bgGradient)
        .task { if settingsVM.isConfigured { await vm.fetchMovies() } else { vm.errorCase = .notConfigured } }
        .fullScreenCover(item: $selected) { MovieDetailView(movie: $0) }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("APIConfigured"))) { _ in
            Task { await vm.fetchMovies() }
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text("مرحباً").font(.title2).bold().foregroundColor(.white)
                Text("استمتع بمشاهدة أحدث الأفلام").font(.subheadline).foregroundColor(.textSec)
            }
            Spacer()
            Button { showSettings = true } label: {
                Image(systemName: "gearshape.fill").font(.title3).foregroundColor(.accentGold)
                    .padding(12).background(.thickMaterial, in: RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16).padding(.top, 8)
        .sheet(isPresented: $showSettings) { SettingsView() }
    }

    private var loading: some View {
        VStack(spacing: 12) {
            ForEach(0..<3) { _ in RoundedRectangle(cornerRadius: 16).fill(Color.cardBg).frame(height: 160) }
        }.padding(.horizontal, 16)
    }

    private var configNeeded: some View {
        VStack(spacing: 16) {
            Spacer().frame(height: 60)
            Image(systemName: "antenna.radiowaves.left.and.right").font(.system(size: 50)).foregroundColor(.accentGold)
            Text("لم يتم إعداد API").font(.title2).bold().foregroundColor(.white)
            Text("لتشغيل الأفلام، يجب إدخال رابط API أو استخدام البيانات التجريبية").multilineTextAlignment(.center).foregroundColor(.textSec).padding(.horizontal)
            Button { showSettings = true } label: {
                Label("فتح الإعدادات", systemImage: "gearshape").font(.headline).foregroundColor(.black)
                    .padding(.horizontal, 30).padding(.vertical, 14).background(Color.accentGold, in: RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(.plain)
            Button("استخدام بيانات تجريبية") { vm.loadMockData() }
                .font(.subheadline).foregroundColor(.accentGold)
            Spacer().frame(height: 80)
        }
        .sheet(isPresented: $showSettings) { SettingsView() }
    }

    private var empty: some View {
        VStack(spacing: 12) {
            Spacer().frame(height: 80)
            Image(systemName: "film.slash").font(.system(size: 50)).foregroundColor(.textSec)
            Text("لا توجد أفلام").foregroundColor(.textSec)
        }
    }

    private func featured(_ m: Movie) -> some View {
        Button { selected = m } label: {
            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: URL(string: m.backdropURL)) { phase in
                    switch phase {
                    case .success(let img): img.resizable().aspectRatio(contentMode: .fill)
                    default: Color.cardBg
                    }
                }.frame(height: 440).clipped()
                LinearGradient(colors: [.clear, .black.opacity(0.9)], startPoint: .center, endPoint: .bottom)
                    .frame(height: 200)
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("مميز").font(.caption).bold().padding(.horizontal, 10).padding(.vertical, 4)
                            .background(Color.accentGold.opacity(0.3), in: RoundedRectangle(cornerRadius: 6)).foregroundColor(.accentGold)
                        Spacer()
                        StarRating(rating: m.rating)
                    }
                    Text(m.displayTitle).font(.system(size: 30, weight: .bold)).foregroundColor(.white).shadow(radius: 4)
                    HStack(spacing: 14) {
                        Label("\(m.year)", systemImage: "calendar").font(.caption)
                        Label("\(m.duration) د", systemImage: "clock").font(.caption)
                    }.foregroundColor(.white.opacity(0.7))
                    HStack(spacing: 8) {
                        ForEach(m.genres.prefix(3)) { g in
                            Text(g.rawValue).font(.caption).padding(.horizontal, 8).padding(.vertical, 3)
                                .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 6)).foregroundColor(.white)
                        }
                    }
                    HStack(spacing: 12) {
                        Label("مشاهدة", systemImage: "play.fill").font(.headline).foregroundColor(.black)
                            .padding(.horizontal, 28).padding(.vertical, 13)
                            .background(Color.accentGold, in: RoundedRectangle(cornerRadius: 13)).glow()
                        Label("", systemImage: "plus").font(.title3).foregroundColor(.white).padding(13)
                            .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 13))
                    }
                }.padding(16)
            }
        }.buttonStyle(.plain).padding(.horizontal, 16)
    }

    private var genres: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("التصنيفات").font(.title3).bold().foregroundColor(.white).padding(.horizontal, 16)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(Genre.allCases) { g in
                        GenreChip(genre: g, isSelected: vm.selectedGenre == g) {
                            withAnimation(.easeOut(duration: 0.2)) { vm.selectedGenre = g }
                        }
                    }
                }.padding(.horizontal, 16)
            }
        }
    }

    private var trending: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("الأكثر مشاهدة").font(.title3).bold().foregroundColor(.white)
                Spacer()
            }.padding(.horizontal, 16)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(vm.filteredMovies) { m in
                        Button { selected = m } label: { MovieCard(movie: m, size: .large) }.buttonStyle(.plain)
                    }
                }.padding(.horizontal, 16)
            }
        }
    }

    private var recent: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("أضيف مؤخراً").font(.title3).bold().foregroundColor(.white).padding(.horizontal, 16)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(vm.recentlyAdded) { m in
                        Button { selected = m } label: { MovieCard(movie: m, size: .medium) }.buttonStyle(.plain)
                    }
                }.padding(.horizontal, 16)
            }
        }
    }
}

extension HomeViewModel {
    var categories: [Genre] { Genre.allCases }
    func loadMockData() { self.loadMockDataPrivate() }
}
