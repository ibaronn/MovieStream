import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var favoritesVM: FavoritesViewModel
    @State private var selectedMovie: Movie?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                headerView

                if favoritesVM.favorites.isEmpty {
                    emptyView
                } else {
                    moviesGrid
                }
            }
            .background(Color.darkBackground)
            .fullScreenCover(item: $selectedMovie) { movie in
                MovieDetailView(movie: movie)
            }
        }
        .onAppear {
            favoritesVM.loadFavorites()
        }
    }

    private var headerView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("المفضلة")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            if !favoritesVM.favorites.isEmpty {
                Text("\(favoritesVM.favorites.count) فيلم")
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var emptyView: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "heart.slash")
                .font(.system(size: 60))
                .foregroundColor(.textSecondary)
            Text("لا توجد أفلام في المفضلة")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.white)
            Text("أضف أفلامك المفضلة من خلال الضغط على أيقونة القلب")
                .font(.subheadline)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
        }
    }

    private var moviesGrid: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 140, maximum: 180), spacing: 12)
            ], spacing: 16) {
                ForEach(favoritesVM.favorites) { movie in
                    Button {
                        selectedMovie = movie
                    } label: {
                        MovieCard(movie: movie, size: .large)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(20)
        }
    }
}
