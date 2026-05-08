import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var trendingMovies: [Movie] = []
    @Published var recentlyAdded: [Movie] = []
    @Published var featuredMovie: Movie?
    @Published var selectedGenre: Genre = .all
    @Published var isLoading = false
    @Published var errorCase: ErrorCase? = nil

    enum ErrorCase: Equatable { case notConfigured, network }

    private let apiService = APIService()

    var filteredMovies: [Movie] {
        if selectedGenre == .all { return trendingMovies }
        return trendingMovies.filter { $0.genres.contains(selectedGenre) }
    }

    func fetchMovies() async {
        isLoading = true; errorCase = nil
        do {
            let r = try await apiService.fetchMovies()
            trendingMovies = r.movies; recentlyAdded = Array(r.movies.suffix(6)); featuredMovie = r.movies.first
        } catch {
            loadMockDataPrivate()
        }
        isLoading = false
    }

    func loadMockDataPrivate() {
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

    func loadMovieDetail(movie: Movie) {
        self.movie = movie
        self.streamingSources = MockData.streamingSources
        self.selectedServer = MockData.streamingSources.first
    }
}

@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchResults: [Movie] = []
    @Published var isSearching = false
    @Published var recentSearches: [String] = []

    func search() async {
        guard !searchText.isEmpty else { return }
        isSearching = true
        if !recentSearches.contains(searchText) {
            recentSearches.insert(searchText, at: 0)
            if recentSearches.count > 10 { recentSearches.removeLast() }
        }
        searchResults = MockData.movies.filter { $0.displayTitle.localizedCaseInsensitiveContains(searchText) }
        isSearching = false
    }

    func clearSearch() { searchText = ""; searchResults = [] }
}

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var favorites: [Movie] = []
    private let defaults = UserDefaults.standard
    private let key = "favorites"

    func loadFavorites() {
        guard let d = defaults.data(forKey: key), let m = try? JSONDecoder().decode([Movie].self, from: d) else { return }
        favorites = m
    }

    func toggleFavorite(_ movie: Movie) {
        if let i = favorites.firstIndex(where: { $0.id == movie.id }) { favorites.remove(at: i) }
        else { favorites.append(movie) }
        save()
    }

    func isFavorite(_ movie: Movie) -> Bool { favorites.contains { $0.id == movie.id } }
    private func save() { guard let d = try? JSONEncoder().encode(favorites) else { return }; defaults.set(d, forKey: key) }
}

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var apiURL: String = UserDefaults.standard.string(forKey: "api_base_url") ?? ""

    var isConfigured: Bool { !apiURL.isEmpty && !apiURL.contains("example.com") }

    func saveURL(_ url: String) {
        apiURL = url
        UserDefaults.standard.set(url, forKey: "api_base_url")
        NotificationCenter.default.post(name: Notification.Name("APIConfigured"), object: nil)
    }
}
