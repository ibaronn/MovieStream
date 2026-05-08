import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedMovie: Movie?
    @State private var showDetail = false
    @Namespace private var animation

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                headerView
                if viewModel.isLoading {
                    loadingView
                } else {
                    if let featured = viewModel.featuredMovie {
                        featuredSection(movie: featured)
                    }
                    genresSection
                    if !viewModel.filteredMovies.isEmpty {
                        trendingSection
                    }
                    recentlyAddedSection
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

    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("مرحباً بك")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("استمتع بمشاهدة أحدث الأفلام")
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
            }
            Spacer()
            Image(systemName: "bell.fill")
                .font(.title3)
                .foregroundColor(.accentGold)
                .padding(12)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }

    private var loadingView: some View {
        VStack(spacing: 16) {
            ForEach(0..<3) { _ in
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.cardBackground)
                    .frame(height: 180)
                    .shimmer()
            }
        }
        .padding(.horizontal, 20)
    }

    private func featuredSection(movie: Movie) -> some View {
        Button {
            selectedMovie = movie
        } label: {
            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: URL(string: movie.backdropURL)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    default:
                        ZStack {
                            Color.cardBackground
                            Image(systemName: "photo.fill")
                                .font(.largeTitle)
                                .foregroundColor(.textSecondary)
                        }
                    }
                }
                .frame(height: 420)
                .clipShape(RoundedRectangle(cornerRadius: 24))

                LinearGradient(
                    gradient: Gradient(colors: [.clear, .black.opacity(0.9)]),
                    startPoint: .center,
                    endPoint: .bottom
                )
                .cornerRadius(24, corners: [.bottomLeft, .bottomRight])

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("مميز")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.accentGold.opacity(0.3), in: RoundedRectangle(cornerRadius: 8))
                            .foregroundColor(.accentGold)
                        Spacer()
                        StarRating(rating: movie.rating)
                    }

                    Text(movie.displayTitle)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(radius: 5)

                    HStack(spacing: 16) {
                        Label("\(movie.year)", systemImage: "calendar")
                        Label("\(movie.duration) دقيقة", systemImage: "clock")
                        if movie.isDubbed { Label("مدبلج", systemImage: "speaker.wave.2.fill") }
                    }
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))

                    HStack(spacing: 12) {
                        ForEach(movie.genres.prefix(3)) { genre in
                            Text(genre.rawValue)
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
                                .foregroundColor(.white)
                        }
                    }

                    HStack(spacing: 12) {
                        Label("مشاهدة الآن", systemImage: "play.fill")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding(.horizontal, 28)
                            .padding(.vertical, 14)
                            .background(Color.accentGold, in: RoundedRectangle(cornerRadius: 14))
                            .glow(color: .accentGold, radius: 10)

                        Label("", systemImage: "plus")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(14)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding(20)
            }
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 20)
    }

    private var genresSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("التصنيفات")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(viewModel.categories) { genre in
                        GenreChip(
                            genre: genre,
                            isSelected: viewModel.selectedGenre == genre
                        ) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                viewModel.selectedGenre = genre
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }

    private var trendingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("الأكثر مشاهدة")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer()
                Text("عرض الكل")
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
                        .transition(.opacity.combined(with: .scale))
                    }
                }
                .padding(.horizontal, 20)
            }
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: viewModel.selectedGenre)
        }
    }

    private var recentlyAddedSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("أضيف مؤخراً")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.recentlyAdded) { movie in
                        Button {
                            selectedMovie = movie
                        } label: {
                            MovieCard(movie: movie, size: .medium)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

extension HomeViewModel {
    var categories: [Genre] { Genre.allCases }
}
