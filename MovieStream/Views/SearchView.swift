import SwiftUI

struct SearchView: View {
    @StateObject private var vm = SearchViewModel()
    @State private var selected: Movie?
    @FocusState private var focused: Bool

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 10) {
                HStack {
                    Image(systemName: "magnifyingglass").foregroundColor(.textSec)
                    TextField("ابحث عن فيلم...", text: $vm.searchText).foregroundColor(.white).focused($focused)
                        .onSubmit { Task { await vm.search() } }
                    if !vm.searchText.isEmpty {
                        Button { vm.clearSearch() } label: { Image(systemName: "xmark.circle.fill").foregroundColor(.textSec) }
                    }
                }.padding(.horizontal, 12).padding(.vertical, 11).background(.thickMaterial, in: RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(.white.opacity(0.1), lineWidth: 1))
                Button { Task { await vm.search() } } label: {
                    Image(systemName: "arrow.left").font(.headline).foregroundColor(.black).padding(13)
                        .background(Color.accentGold, in: RoundedRectangle(cornerRadius: 13))
                }.buttonStyle(.plain)
            }.padding(.horizontal, 16).padding(.top, 8)

            if vm.searchText.isEmpty {
                recentView
            } else if vm.isSearching {
                Spacer(); ProgressView().tint(.accentGold); Spacer()
            } else if vm.searchResults.isEmpty && !vm.searchText.isEmpty {
                emptyView
            } else {
                resultsView
            }
        }.background(Color.bgGradient).fullScreenCover(item: $selected) { MovieDetailView(movie: $0) }
    }

    private var recentView: some View {
        Group {
            if !vm.recentSearches.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("عمليات البحث الأخيرة").font(.headline).foregroundColor(.white).padding(.horizontal, 16).padding(.top, 20)
                    ForEach(vm.recentSearches, id: \.self) { q in
                        Button {
                            vm.searchText = q; Task { await vm.search() }
                        } label: {
                            HStack {
                                Image(systemName: "clock.arrow.circlepath").foregroundColor(.textSec)
                                Text(q).foregroundColor(.white); Spacer()
                            }.padding(.horizontal, 16).padding(.vertical, 6)
                        }.buttonStyle(.plain)
                    }
                }
            } else {
                Spacer()
                VStack(spacing: 12) { Image(systemName: "film.stack").font(.system(size: 50)).foregroundColor(.textSec)
                    Text("ابحث عن أفلامك المفضلة").foregroundColor(.textSec) }
                Spacer()
            }
        }
    }

    private var emptyView: some View {
        VStack(spacing: 12) { Spacer()
            Image(systemName: "magnifyingglass").font(.system(size: 40)).foregroundColor(.textSec)
            Text("لا توجد نتائج").foregroundColor(.white)
            Text("تأكد من الإملاء أو جرب بحثاً آخر").foregroundColor(.textSec).font(.subheadline)
            Spacer()
        }
    }

    private var resultsView: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140, maximum: 170), spacing: 10)], spacing: 14) {
                ForEach(vm.searchResults) { m in
                    Button { selected = m } label: { MovieCard(movie: m, size: .large) }.buttonStyle(.plain)
                }
            }.padding(16)
        }
    }
}
