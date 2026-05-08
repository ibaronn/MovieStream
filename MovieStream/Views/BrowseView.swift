import SwiftUI

struct BrowseView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedMovie: Movie?
    private let columns = [
        GridItem(.adaptive(minimum: 100, maximum: 120), spacing: 16)
    ]

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    headerView
                    categoriesGrid
                    if viewModel.selectedGenre != .all {
                        genreMoviesSection
                    }
                }
                .padding(.bottom, 16)
            }
            .background(Color.darkBackground)
            .task { await viewModel.fetchMovies() }
            .fullScreenCover(item: $selectedMovie) { movie in
                MovieDetailView(movie: movie)
            }
        }
    }

    private var headerView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("تصفح التصنيفات")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text("اختر التصنيف الذي يناسبك")
                .font(.subheadline)
                .foregroundColor(.textSecondary)
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var categoriesGrid: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(Array(Genre.allCases.dropFirst())) { genre in
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        viewModel.selectedGenre = genre
                    }
                } label: {
                    CategoryCard(genre: genre)
                }
                .buttonStyle(.plain)
                .scaleEffect(viewModel.selectedGenre == genre ? 0.95 : 1)
            }
        }
        .padding(.horizontal, 20)
    }

    private var genreMoviesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(viewModel.selectedGenre.rawValue)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer()
                Button("إلغاء التصفية") {
                    withAnimation {
                        viewModel.selectedGenre = .all
                    }
                }
                .font(.subheadline)
                .foregroundColor(.accentGold)
            }
            .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.filteredMovies) { movie in
                        Button {
                            selectedMovie = movie
                        } label: {
                            MovieCard(movie: movie, size: .large)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}
