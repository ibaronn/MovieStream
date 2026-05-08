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
        content
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: cornerRadius)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(.white.opacity(0.12), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 8)
    }
}

// MARK: - Movie Card
struct MovieCard: View {
    let movie: Movie
    var size: CardSize = .medium

    enum CardSize {
        case small, medium, large, hero

        var dimensions: CGSize {
            switch self {
            case .small: return CGSize(width: 100, height: 150)
            case .medium: return CGSize(width: 140, height: 210)
            case .large: return CGSize(width: 180, height: 270)
            case .hero: return CGSize(width: UIScreen.main.bounds.width - 48, height: 480)
            }
        }
    }

    var body: some View {
        AsyncImage(url: URL(string: movie.posterURL)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            default:
                ZStack {
                    Color.cardBackground
                    Image(systemName: "film.fill")
                        .font(.title2)
                        .foregroundColor(.textSecondary)
                }
            }
        }
        .frame(width: size.dimensions.width, height: size.dimensions.height)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(alignment: .bottom) {
            if size == .large || size == .hero {
                LinearGradient(
                    gradient: Gradient(colors: [.clear, .black.opacity(0.8)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: size.dimensions.height * 0.4)
                .cornerRadius(12, corners: [.bottomLeft, .bottomRight])
            }
        }
        .overlay(alignment: .bottomLeading) {
            if size == .large || size == .hero {
                VStack(alignment: .leading, spacing: 4) {
                    Text(movie.displayTitle)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    HStack(spacing: 8) {
                        Label("\(movie.year)", systemImage: "calendar")
                        Label(String(format: "%.1f", movie.rating), systemImage: "star.fill")
                            .foregroundColor(.ratingGold)
                    }
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                }
                .padding(12)
            }
        }
        .overlay(alignment: .topTrailing) {
            if movie.isDubbed || movie.isSubtitled {
                HStack(spacing: 4) {
                    if movie.isDubbed {
                        Text("مدبلج")
                            .font(.system(size: size == .small ? 8 : 9, weight: .bold))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 6))
                            .foregroundColor(.white)
                    }
                    if movie.isSubtitled {
                        Text("مترجم")
                            .font(.system(size: size == .small ? 8 : 9, weight: .bold))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 6))
                            .foregroundColor(.white)
                    }
                }
                .padding(8)
            }
        }
        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Genre Chip
struct GenreChip: View {
    let genre: Genre
    let isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: genre.icon)
                    .font(.caption)
                Text(genre.rawValue)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .bold : .medium)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                isSelected
                    ? Color.accentGold.opacity(0.3)
                    : .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 20)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color.accentGold : .white.opacity(0.1), lineWidth: 1.5)
            )
            .foregroundColor(isSelected ? .accentGold : .white)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Category Card
struct CategoryCard: View {
    let genre: Genre

    var body: some View {
        GlassCard(cornerRadius: 20) {
            VStack(spacing: 12) {
                Image(systemName: genre.icon)
                    .font(.system(size: 28))
                    .foregroundColor(.accentGold)
                    .glow(color: .accentGold, radius: 10)

                Text(genre.rawValue)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 100, height: 100)
            .padding(8)
        }
    }
}

// MARK: - Star Rating
struct StarRating: View {
    let rating: Double
    var maximum: Int = 5

    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<maximum, id: \.self) { index in
                Image(systemName: index < Int(rating.rounded()) ? "star.fill" : "star")
                    .font(.caption)
                    .foregroundColor(.ratingGold)
            }
            Text(String(format: "%.1f", rating))
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.ratingGold)
                .padding(.leading, 4)
        }
    }
}

// MARK: - Quality Badge
struct QualityBadge: View {
    let quality: String
    var isSelected: Bool = false

    var body: some View {
        Text(quality)
            .font(.caption)
            .fontWeight(.bold)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                isSelected
                    ? Color.accentGold.opacity(0.3)
                    : .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 8)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.accentGold : .white.opacity(0.1), lineWidth: 1)
            )
            .foregroundColor(isSelected ? .accentGold : .white)
    }
}

// MARK: - Animated Tab Bar
struct AnimatedTabBar: View {
    @Binding var selectedTab: AppTab
    @Namespace private var tabAnimation

    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tab.rawValue)
                            .font(.system(size: 20))
                            .fontWeight(selectedTab == tab ? .bold : .regular)
                            .frame(height: 24)

                        Text(tab.arabicTitle)
                            .font(.system(size: 9))
                            .fontWeight(selectedTab == tab ? .bold : .medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background {
                        if selectedTab == tab {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.accentGold.opacity(0.15))
                                .matchedGeometryEffect(id: "tab_bg", in: tabAnimation)
                        }
                    }
                }
                .buttonStyle(.plain)
                .foregroundColor(selectedTab == tab ? .accentGold : .textSecondary)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(.white.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: -5)
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
}
