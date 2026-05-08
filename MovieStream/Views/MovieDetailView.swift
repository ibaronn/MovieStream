import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @StateObject private var vm = MovieDetailViewModel()
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var favoritesVM: FavoritesViewModel
    @State private var showPlayer = false

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.bgGradient.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    backdrop
                    info
                    servers
                    cast
                }
            }
            Button { dismiss() } label: {
                Image(systemName: "xmark").font(.headline).foregroundColor(.white).padding(12)
                    .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 12))
            }.padding(12)
        }
        .onAppear { vm.loadMovieDetail(movie: movie) }
        .fullScreenCover(isPresented: $showPlayer) {
            if let s = vm.selectedServer, let q = s.qualities.first(where: { $0.label == vm.selectedQuality }) ?? s.qualities.first {
                MoviePlayerView(streamURL: URL(string: q.url)!, isEmbed: s.type == .embed, movieTitle: movie.displayTitle)
            }
        }
    }

    private var backdrop: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: URL(string: movie.backdropURL)) { ph in
                switch ph {
                case .success(let img): img.resizable().aspectRatio(contentMode: .fill)
                default: Color.cardBg
                }
            }.frame(height: 270).clipped()
            LinearGradient(colors: [.clear, .bgBot], startPoint: .top, endPoint: .bottom).frame(height: 80)
            HStack(alignment: .bottom) {
                MovieCard(movie: movie, size: .medium).offset(y: 40)
                Spacer()
                Button {
                    favoritesVM.toggleFavorite(movie)
                } label: {
                    Image(systemName: favoritesVM.isFavorite(movie) ? "heart.fill" : "heart")
                        .font(.title3).foregroundColor(favoritesVM.isFavorite(movie) ? .red : .white).padding(13)
                        .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 13)).offset(y: 40)
                }.buttonStyle(.plain)
            }.padding(.horizontal, 16)
        }
    }

    private var info: some View {
        VStack(alignment: .leading, spacing: 10) {
            Spacer().frame(height: 50)
            Text(movie.displayTitle).font(.system(size: 26, weight: .bold)).foregroundColor(.white)
            HStack(spacing: 14) {
                StarRating(rating: movie.rating)
                Text("\(movie.year)").font(.subheadline).foregroundColor(.textSec)
                Text("\(movie.duration) دقيقة").font(.subheadline).foregroundColor(.textSec)
            }
            HStack(spacing: 6) {
                ForEach(movie.qualities, id: \.self) { QualityBadge(quality: $0) }
                if movie.isDubbed { QualityBadge(quality: "مدبلج") }
                if movie.isSubtitled { QualityBadge(quality: "مترجم") }
            }
            Text(movie.displayOverview).font(.body).foregroundColor(.textSec).lineSpacing(3)
            HStack {
                Text("المخرج:").font(.subheadline).foregroundColor(.white)
                Text(movie.director).font(.subheadline).foregroundColor(.textSec)
            }
        }.padding(.horizontal, 16)
    }

    private var servers: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("سيرفرات المشاهدة").font(.title3).bold().foregroundColor(.white).padding(.horizontal, 16).padding(.top, 20)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(vm.streamingSources) { s in
                        Button {
                            vm.selectedServer = s
                        } label: {
                            VStack(spacing: 6) {
                                Image(systemName: s.type == .embed ? "globe" : "play.rectangle").font(.title2)
                                    .foregroundColor(vm.selectedServer?.id == s.id ? .accentGold : .white)
                                Text(s.serverNameArabic).font(.caption).fontWeight(.medium)
                                    .foregroundColor(vm.selectedServer?.id == s.id ? .accentGold : .white)
                            }.padding(.horizontal, 22).padding(.vertical, 14)
                                .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 14))
                                .overlay(RoundedRectangle(cornerRadius: 14).stroke(vm.selectedServer?.id == s.id ? Color.accentGold : .clear, lineWidth: 2))
                        }.buttonStyle(.plain)
                    }
                }.padding(.horizontal, 16)
            }
            if let s = vm.selectedServer {
                VStack(alignment: .leading, spacing: 8) {
                    Text("اختر الدقة:").font(.subheadline).fontWeight(.medium).foregroundColor(.white)
                    HStack(spacing: 8) {
                        ForEach(s.qualities) { q in
                            Button { vm.selectedQuality = q.label } label: {
                                QualityBadge(quality: q.label, isSelected: vm.selectedQuality == q.label)
                            }.buttonStyle(.plain)
                        }
                    }
                }.padding(.horizontal, 16)
            }
            Button {
                showPlayer = true
            } label: {
                Label("مشاهدة الآن", systemImage: "play.fill").font(.headline).foregroundColor(.black)
                    .frame(maxWidth: .infinity).padding(.vertical, 15)
                    .background(Color.accentGold, in: RoundedRectangle(cornerRadius: 16)).glow()
            }.buttonStyle(.plain).padding(.horizontal, 16).padding(.top, 6)
        }
    }

    private var cast: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("طاقم العمل").font(.title3).bold().foregroundColor(.white).padding(.horizontal, 16).padding(.top, 12)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(movie.cast, id: \.self) { a in
                        VStack(spacing: 6) {
                            Image(systemName: "person.circle.fill").font(.system(size: 44)).foregroundColor(.textSec)
                            Text(a).font(.caption).foregroundColor(.white).lineLimit(1).frame(width: 80).multilineTextAlignment(.center)
                        }
                    }
                }.padding(.horizontal, 16)
            }
            .padding(.bottom, 30)
        }
    }
}
