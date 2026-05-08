import SwiftUI

struct BrowseView: View {
    @StateObject private var vm = HomeViewModel()
    @State private var selected: Movie?
    private let cols = [GridItem(.adaptive(minimum: 100, maximum: 120), spacing: 14)]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("تصفح التصنيفات").font(.largeTitle).bold().foregroundColor(.white)
                    Text("اختر التصنيف الذي يناسبك").font(.subheadline).foregroundColor(.textSec)
                }.frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal, 16).padding(.top, 8)

                LazyVGrid(columns: cols, spacing: 14) {
                    ForEach(Array(Genre.allCases.dropFirst())) { g in
                        Button { withAnimation(.easeOut) { vm.selectedGenre = g } } label: {
                            CategoryCard(genre: g).scaleEffect(vm.selectedGenre == g ? 0.93 : 1)
                        }.buttonStyle(.plain)
                    }
                }.padding(.horizontal, 16)

                if vm.selectedGenre != .all {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(vm.selectedGenre.rawValue).font(.title3).bold().foregroundColor(.white)
                            Spacer()
                            Button("إلغاء") { withAnimation { vm.selectedGenre = .all } }.font(.subheadline).foregroundColor(.accentGold)
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
            }.padding(.bottom, 8)
        }
        .background(Color.bgGradient)
        .task { await vm.fetchMovies() }
        .fullScreenCover(item: $selected) { MovieDetailView(movie: $0) }
    }
}
