import SwiftUI
import AVKit
import AVFoundation
import WebKit

struct MoviePlayerView: View {
    let streamURL: URL
    let isEmbed: Bool
    let movieTitle: String
    @Environment(\.dismiss) private var dismiss
    @State private var player: AVPlayer?
    @State private var isPlaying = true
    @State private var showControls = false
    @State private var currentTime: Double = 0
    @State private var totalTime: Double = 0

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if isEmbed {
                WebView(url: streamURL)
                    .edgesIgnoringSafeArea(.all)
            } else {
                if let player = player {
                    VideoPlayerController(player: player, isPlaying: $isPlaying, currentTime: $currentTime, totalTime: $totalTime)
                        .edgesIgnoringSafeArea(.all)
                }
            }

            if showControls {
                controlsOverlay
                    .transition(.opacity)
            }

            VStack {
                HStack {
                    Button {
                        player?.pause()
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                    }
                    Spacer()
                    Text(movieTitle)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    Spacer()
                    Color.clear.frame(width: 44, height: 44)
                }
                .padding(16)
                Spacer()
            }
            .opacity(showControls ? 1 : 0)
        }
        .onAppear {
            if !isEmbed {
                player = AVPlayer(url: streamURL)
                player?.play()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeInOut) {
                    showControls = false
                }
            }
        }
        .onDisappear {
            player?.pause()
            player = nil
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                showControls.toggle()
            }
            if showControls {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    withAnimation(.easeInOut) {
                        showControls = false
                    }
                }
            }
        }
    }

    private var controlsOverlay: some View {
        VStack {
            Spacer()
            if !isEmbed {
                VStack(spacing: 12) {
                    HStack {
                        Text(formatTime(currentTime))
                            .font(.caption)
                            .foregroundColor(.white)
                        Slider(value: $currentTime, in: 0...totalTime) { editing in
                            if !editing {
                                player?.seek(to: CMTime(seconds: currentTime, preferredTimescale: 600))
                            }
                        }
                        .tint(.accentGold)
                        Text(formatTime(totalTime))
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)

                    HStack(spacing: 40) {
                        Button {
                            player?.seek(to: CMTime(seconds: max(0, currentTime - 10), preferredTimescale: 600))
                        } label: {
                            Image(systemName: "gobackward.10")
                                .font(.title2)
                                .foregroundColor(.white)
                        }

                        Button {
                            if isPlaying {
                                player?.pause()
                            } else {
                                player?.play()
                            }
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                isPlaying.toggle()
                            }
                        } label: {
                            Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .font(.system(size: 54))
                                .foregroundColor(.white)
                                .glow(color: .white, radius: 10)
                        }

                        Button {
                            player?.seek(to: CMTime(seconds: min(totalTime, currentTime + 10), preferredTimescale: 600))
                        } label: {
                            Image(systemName: "goforward.10")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.bottom, 40)
                .padding(.top, 20)
                .background {
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.8)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
            }
        }
    }

    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - WebView for Embed Streams
struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.scrollView.isScrollEnabled = false
        webView.backgroundColor = .black
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}
}

// MARK: - Video Player Controller
struct VideoPlayerController: UIViewControllerRepresentable {
    let player: AVPlayer
    @Binding var isPlaying: Bool
    @Binding var currentTime: Double
    @Binding var totalTime: Double

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
        context.coordinator.addTimeObserver(player: player, controller: controller)
        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        if isPlaying {
            uiViewController.player?.play()
        } else {
            uiViewController.player?.pause()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        let parent: VideoPlayerController
        var timeObserver: Any?

        init(_ parent: VideoPlayerController) {
            self.parent = parent
        }

        func addTimeObserver(player: AVPlayer, controller: AVPlayerViewController) {
            guard let item = player.currentItem else { return }
            parent.totalTime = item.duration.seconds

            timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: .main) { time in
                self.parent.currentTime = time.seconds
                self.parent.totalTime = item.duration.seconds
            }
        }

        deinit {
            if let observer = timeObserver {
                parent.player.removeTimeObserver(observer)
            }
        }
    }
}
