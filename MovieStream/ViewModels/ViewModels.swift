import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var trendingMovies: [Movie] = []
    @Published var recentlyAdded: [Movie] = []
    @Published var featuredMovie: Movie?
    @Published var selectedGenre: Genre = .all
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let apiService = APIService()

    var filteredMovies: [Movie] {
        if selectedGenre == .all { return trendingMovies }
        return trendingMovies.filter { $0.genres.contains(selectedGenre) }
    }

    func fetchMovies() async {
        isLoading = true
        errorMessage = nil
        do {
            let response = try await apiService.fetchMovies()
            trendingMovies = response.movies
            recentlyAdded = Array(response.movies.suffix(6))
            featuredMovie = response.movies.first
        } catch {
            errorMessage = error.localizedDescription
            loadMockData()
        }
        isLoading = false
    }

    private func loadMockData() {
        trendingMovies = MockData.movies
        recentlyAdded = Array(MockData.movies.shuffled().prefix(6))
        featuredMovie = MockData.movies.first
    }
}

@MainActor
class MovieDetailViewModel: ObservableObject {
    @Published var movie: Movie?
    @Published var streamingSources: [StreamingSource] = []
    @Published var isLoading = false
    @Published var selectedServer: StreamingSource?
    @Published var selectedQuality: String = "1080p"

    private let apiService = APIService()

    func loadMovieDetail(movie: Movie) {
        self.movie = movie
        self.streamingSources = MockData.streamingSources
        self.selectedServer = MockData.streamingSources.first
    }

    func loadStreamingSources(movieId: Int) async {
        isLoading = true
        do {
            let sources = try await apiService.fetchStreamingSources(movieId: movieId)
            streamingSources = sources
            selectedServer = sources.first
        } catch {
            streamingSources = MockData.streamingSources
            selectedServer = MockData.streamingSources.first
        }
        isLoading = false
    }
}

@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchResults: [Movie] = []
    @Published var isSearching = false
    @Published var recentSearches: [String] = []

    private let apiService = APIService()

    var suggestions: [String] {
        if searchText.isEmpty { return recentSearches }
        return MockData.movies
            .filter { $0.displayTitle.localizedCaseInsensitiveContains(searchText) }
            .map { $0.displayTitle }
    }

    func search() async {
        guard !searchText.isEmpty else { return }
        isSearching = true
        if !recentSearches.contains(searchText) {
            recentSearches.insert(searchText, at: 0)
            if recentSearches.count > 10 { recentSearches.removeLast() }
        }
        do {
            let results = try await apiService.searchMovies(query: searchText)
            searchResults = results
        } catch {
            searchResults = MockData.movies.filter {
                $0.displayTitle.localizedCaseInsensitiveContains(searchText)
            }
        }
        isSearching = false
    }

    func clearSearch() {
        searchText = ""
        searchResults = []
    }
}

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var favorites: [Movie] = []
    private let defaults = UserDefaults.standard
    private let favoritesKey = "favorites"

    func loadFavorites() {
        guard let data = defaults.data(forKey: favoritesKey),
              let movies = try? JSONDecoder().decode([Movie].self, from: data) else { return }
        favorites = movies
    }

    func toggleFavorite(_ movie: Movie) {
        if let index = favorites.firstIndex(where: { $0.id == movie.id }) {
            favorites.remove(at: index)
        } else {
            favorites.append(movie)
        }
        saveFavorites()
    }

    func isFavorite(_ movie: Movie) -> Bool {
        favorites.contains(where: { $0.id == movie.id })
    }

    private func saveFavorites() {
        guard let data = try? JSONEncoder().encode(favorites) else { return }
        defaults.set(data, forKey: favoritesKey)
    }
}
