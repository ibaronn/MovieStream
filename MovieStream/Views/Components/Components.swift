import SwiftUI

// MARK: - Glass Card
struct GlassCard<Content: View>: View {
    let content: Content
    var cornerRadius: CGFloat = 16
    init(cornerRadius: CGFloat = 16, @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius
        self.content = content()
    }
    var body: some View {
        content.glass(cornerRadius: cornerRadius)
    }
}

// MARK: - Movie Card
struct MovieCard: View {
    let movie: Movie
    var size: CardSize = .medium
    enum CardSize { case small, medium, large, hero
        var w: CGFloat {
            switch self {
            case .small: return 100; case .medium: return 140
            case .large: return 170; case .hero: return UIScreen.main.bounds.width - 40
            }
        }
        var h: CGFloat {
            switch self {
            case .small: return 150; case .medium: return 210
            case .large: return 250; case .hero: return 460
            }
        }
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: movie.posterURL)) { phase in
                switch phase {
                case .success(let img): img.resizable().aspectRatio(contentMode: .fill)
                default: ZStack { Color.cardBg; Image(systemName: "film").foregroundColor(.textSec) }
                }
            }
            .frame(width: size.w, height: size.h)
            .clipped()
            if size == .hero {
                LinearGradient(colors: [.clear, .black.opacity(0.85)], startPoint: .center, endPoint: .bottom)
                    .frame(height: size.h * 0.5)
                VStack(alignment: .leading, spacing: 6) {
                    Text(movie.displayTitle).font(.title2).bold().foregroundColor(.white).lineLimit(2)
                    HStack(spacing: 12) {
                        Label("\(movie.year)", systemImage: "calendar").font(.caption)
                        Label("\(movie.rating, specifier: "%.1f")", systemImage: "star.fill").foregroundColor(.ratingGold).font(.caption)
                    }
                }.padding()
            }
            if movie.isDubbed || movie.isSubtitled {
                VStack(spacing: 3) {
                    if movie.isDubbed { label("مدبلج") }
                    if movie.isSubtitled { label("مترجم") }
                }.padding(6).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            }
        }
        .frame(width: size.w, height: size.h)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.4), radius: size == .hero ? 15 : 6)
    }

    func label(_ text: String) -> some View {
        Text(text).font(.system(size: 9, weight: .bold)).padding(.horizontal, 6).padding(.vertical, 3)
            .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 5)).foregroundColor(.white)
    }
}

// MARK: - Genre Chip
struct GenreChip: View {
    let genre: Genre; let isSelected: Bool; var action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Image(systemName: genre.icon).font(.caption)
                Text(genre.rawValue).font(.subheadline).fontWeight(isSelected ? .bold : .medium)
            }
            .padding(.horizontal, 14).padding(.vertical, 8)
            .background(
                isSelected ? AnyShapeStyle(Color.accentGold.opacity(0.25)) : AnyShapeStyle(.thickMaterial),
                in: RoundedRectangle(cornerRadius: 20)
            )
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(isSelected ? Color.accentGold : .white.opacity(0.1), lineWidth: 1.5))
            .foregroundColor(isSelected ? .accentGold : .white)
        }.buttonStyle(.plain)
    }
}

// MARK: - Category Card
struct CategoryCard: View {
    let genre: Genre
    var body: some View {
        GlassCard(cornerRadius: 20) {
            VStack(spacing: 10) {
                Image(systemName: genre.icon).font(.system(size: 26)).foregroundColor(.accentGold)
                Text(genre.rawValue).font(.headline).foregroundColor(.white).multilineTextAlignment(.center)
            }.frame(width: 100, height: 100).padding(8)
        }
    }
}

// MARK: - Quality Badge
struct QualityBadge: View {
    let quality: String; var isSelected: Bool = false
    var body: some View {
        Text(quality).font(.caption).fontWeight(.bold).padding(.horizontal, 10).padding(.vertical, 5)
            .background(
                isSelected ? AnyShapeStyle(Color.accentGold.opacity(0.25)) : AnyShapeStyle(.thickMaterial),
                in: RoundedRectangle(cornerRadius: 8)
            )
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(isSelected ? Color.accentGold : .white.opacity(0.1), lineWidth: 1))
            .foregroundColor(isSelected ? .accentGold : .white)
    }
}

// MARK: - Animated Tab Bar
struct AppTabBar: View {
    @Binding var selectedTab: AppTab
    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                TabButton(tab: tab, isSelected: selectedTab == tab) { selectedTab = tab }
            }
        }
        .padding(.horizontal, 8).padding(.vertical, 6)
        .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 24))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(.white.opacity(0.1), lineWidth: 1))
        .shadow(color: .black.opacity(0.4), radius: 15)
        .padding(.horizontal, 12).padding(.bottom, 8)
    }
}

struct TabButton: View {
    let tab: AppTab; let isSelected: Bool; let action: () -> Void
    var body: some View {
        Button(action: action) {
            VStack(spacing: 3) {
                Image(systemName: tab.rawValue).font(.system(size: 20)).frame(height: 22)
                Text(tab.arabicTitle).font(.system(size: 9)).fontWeight(isSelected ? .bold : .medium)
            }
            .frame(maxWidth: .infinity).padding(.vertical, 8)
            .background(isSelected ? Color.accentGold.opacity(0.15) : nil, in: RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
        .foregroundColor(isSelected ? .accentGold : .textSec)
    }
}

// MARK: - Star Rating
struct StarRating: View {
    let rating: Double; var max: Int = 5
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<max, id: \.self) { i in
                Image(systemName: i < Int(rating.rounded()) ? "star.fill" : "star").font(.caption).foregroundColor(.ratingGold)
            }
            Text("\(rating, specifier: "%.1f")").font(.caption).fontWeight(.bold).foregroundColor(.ratingGold)
        }
    }
}
