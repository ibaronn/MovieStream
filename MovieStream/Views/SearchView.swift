import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var selectedMovie: Movie?
    @FocusState private var isSearchFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                searchBar
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                if viewModel.searchText.isEmpty {
                    recentSearchesView
                } else if viewModel.isSearching {
                    Spacer()
                    ProgressView()
                        .tint(.accentGold)
                    Spacer()
                } else if viewModel.searchResults.isEmpty {
                    emptyResultsView
                } else {
                    searchResultsView
                }
            }
            .background(Color.darkBackground)
            .fullScreenCover(item: $selectedMovie) { movie in
                MovieDetailView(movie: movie)
            }
        }
    }

    private var searchBar: some View {
        HStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.textSecondary)
                TextField("ابحث عن فيلم أو مسلسل...", text: $viewModel.searchText)
                    .foregroundColor(.white)
                    .focused($isSearchFocused)
                    .onSubmit {
                        Task { await viewModel.search() }
                    }
                if !viewModel.searchText.isEmpty {
                    Button {
                        viewModel.clearSearch()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.textSecondary)
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.white.opacity(0.1), lineWidth: 1)
            )

            Button {
                Task { await viewModel.search() }
            } label: {
                Image(systemName: "arrow.left")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(14)
                    .background(Color.accentGold, in: RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(.plain)
        }
    }

    private var recentSearchesView: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !viewModel.recentSearches.isEmpty {
                Text("عمليات البحث الأخيرة")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.top, 24)

                ForEach(viewModel.recentSearches, id: \.self) { query in
                    Button {
                        viewModel.searchText = query
                        Task { await viewModel.search() }
                    } label: {
                        HStack {
                            Image(systemName: "clock.arrow.circlepath")
                                .foregroundColor(.textSecondary)
                            Text(query)
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "arrow.up.left")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(.plain)
                }
            } else {
                Spacer()
                VStack(spacing: 16) {
                    Image(systemName: "film.stack")
                        .font(.system(size: 60))
                        .foregroundColor(.textSecondary)
                    Text("ابحث عن أفلامك المفضلة")
                        .font(.title3)
                        .foregroundColor(.textSecondary)
                }
                .frame(maxWidth: .infinity)
                Spacer()
            }
        }
    }

    private var emptyResultsView: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.textSecondary)
            Text("لا توجد نتائج لـ \"\(viewModel.searchText)\"")
                .font(.headline)
                .foregroundColor(.white)
            Text("تأكد من الإملاء أو جرب بحثاً آخر")
                .font(.subheadline)
                .foregroundColor(.textSecondary)
            Spacer()
        }
    }

    private var searchResultsView: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 140, maximum: 180), spacing: 12)
            ], spacing: 16) {
                ForEach(viewModel.searchResults) { movie in
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
