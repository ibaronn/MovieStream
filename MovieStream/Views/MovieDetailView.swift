import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @StateObject private var viewModel = MovieDetailViewModel()
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var favoritesVM: FavoritesViewModel
    @State private var showPlayer = false

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.darkBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    backdropSection
                    infoSection
                    serverSection
                    castSection
                }
            }

            closeButton
        }
        .onAppear {
            viewModel.loadMovieDetail(movie: movie)
        }
        .fullScreenCover(isPresented: $showPlayer) {
            if let server = viewModel.selectedServer,
               let quality = server.qualities.first(where: { $0.label == viewModel.selectedQuality }) ?? server.qualities.first {
                MoviePlayerView(
                    streamURL: URL(string: quality.url)!,
                    isEmbed: server.type == .embed,
                    movieTitle: movie.displayTitle
                )
            }
        }
    }

    private var closeButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
                .foregroundColor(.white)
                .padding(12)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
        .padding(16)
    }

    private var backdropSection: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: URL(string: movie.backdropURL)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                default:
                    Color.cardBackground
                }
            }
            .frame(height: 280)
            .clipped()

            LinearGradient(
                gradient: Gradient(colors: [.clear, .darkBackground]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 100)

            HStack(alignment: .bottom) {
                MovieCard(movie: movie, size: .medium)
                    .offset(y: 50)

                Spacer()

                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        favoritesVM.toggleFavorite(movie)
                    }
                } label: {
                    Image(systemName: favoritesVM.isFavorite(movie) ? "heart.fill" : "heart")
                        .font(.title3)
                        .foregroundColor(favoritesVM.isFavorite(movie) ? .red : .white)
                        .padding(14)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
                        .offset(y: 50)
                }
            }
            .padding(.horizontal, 20)
        }
    }

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Spacer().frame(height: 60)

            Text(movie.displayTitle)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)

            HStack(spacing: 16) {
                StarRating(rating: movie.rating)
                Text("\(movie.year)")
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
                Text("\(movie.duration) دقيقة")
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
            }

            HStack(spacing: 8) {
                ForEach(movie.qualities, id: \.self) { quality in
                    QualityBadge(quality: quality)
                }
                if movie.isDubbed {
                    QualityBadge(quality: "مدبلج")
                }
                if movie.isSubtitled {
                    QualityBadge(quality: "مترجم")
                }
            }

            Text(movie.displayOverview)
                .font(.body)
                .foregroundColor(.textSecondary)
                .lineSpacing(4)

            HStack {
                Text("المخرج:")
                    .font(.subheadline)
                    .foregroundColor(.white)
                Text(movie.director)
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
            }
        }
        .padding(.horizontal, 20)
    }

    private var serverSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("سيرفرات المشاهدة")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.top, 24)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.streamingSources) { source in
                        Button {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                viewModel.selectedServer = source
                            }
                        } label: {
                            GlassCard(cornerRadius: 14) {
                                VStack(spacing: 8) {
                                    Image(systemName: source.type == .embed ? "globe" : "play.rectangle")
                                        .font(.title2)
                                        .foregroundColor(viewModel.selectedServer?.id == source.id ? .accentGold : .white)
                                    Text(source.serverNameArabic)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(viewModel.selectedServer?.id == source.id ? .accentGold : .white)
                                }
                                .padding(.horizontal, 24)
                                .padding(.vertical, 16)
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(viewModel.selectedServer?.id == source.id ? Color.accentGold : .clear, lineWidth: 2)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
            }

            if let server = viewModel.selectedServer {
                VStack(alignment: .leading, spacing: 10) {
                    Text("اختر الدقة:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)

                    HStack(spacing: 10) {
                        ForEach(server.qualities) { quality in
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    viewModel.selectedQuality = quality.label
                                }
                            } label: {
                                QualityBadge(quality: quality.label, isSelected: viewModel.selectedQuality == quality.label)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }

            Button {
                showPlayer = true
            } label: {
                HStack {
                    Image(systemName: "play.fill")
                    Text("مشاهدة الآن")
                }
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.accentGold, in: RoundedRectangle(cornerRadius: 16))
                .glow(color: .accentGold, radius: 15)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .buttonStyle(.plain)
        }
    }

    private var castSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("طاقم العمل")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.top, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(movie.cast, id: \.self) { actor in
                        VStack(spacing: 8) {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.textSecondary)
                            Text(actor)
                                .font(.caption)
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .frame(width: 80)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 30)
        }
    }
}
