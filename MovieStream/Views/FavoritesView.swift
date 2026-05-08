import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var fav: FavoritesViewModel
    @State private var selected: Movie?

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text("المفضلة").font(.largeTitle).bold().foregroundColor(.white)
                if !fav.favorites.isEmpty { Text("\(fav.favorites.count) فيلم").font(.subheadline).foregroundColor(.textSec) }
            }.frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal, 16).padding(.top, 8)

            if fav.favorites.isEmpty {
                Spacer()
                VStack(spacing: 12) {
                    Image(systemName: "heart.slash").font(.system(size: 50)).foregroundColor(.textSec)
                    Text("لا توجد أفلام في المفضلة").foregroundColor(.white)
                    Text("أضف أفلامك من خلال الضغط على أيقونة القلب").foregroundColor(.textSec).font(.subheadline)
                }
                Spacer()
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 140, maximum: 170), spacing: 10)], spacing: 14) {
                        ForEach(fav.favorites) { m in
                            Button { selected = m } label: { MovieCard(movie: m, size: .large) }.buttonStyle(.plain)
                        }
                    }.padding(16)
                }
            }
        }
        .background(Color.bgGradient)
        .fullScreenCover(item: $selected) { MovieDetailView(movie: $0) }
        .onAppear { fav.loadFavorites() }
    }
}
