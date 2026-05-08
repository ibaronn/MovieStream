import SwiftUI
import AVKit
import AVFoundation
import WebKit

struct MoviePlayerView: View {
    let streamURL: URL; let isEmbed: Bool; let movieTitle: String
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
                WebView(url: streamURL).edgesIgnoringSafeArea(.all)
            } else if let p = player {
                VideoPlayerWrap(player: p, isPlaying: $isPlaying, currentTime: $currentTime, totalTime: $totalTime)
                    .edgesIgnoringSafeArea(.all)
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "play.slash").font(.system(size: 50)).foregroundColor(.textSec)
                    Text("لا يمكن تشغيل الفيديو").foregroundColor(.white)
                    Text("تأكد من إعداد API في الإعدادات").foregroundColor(.textSec).font(.caption)
                }
            }
            if showControls { controls.opacity(1) } else { controls.opacity(0) }
        }
        .onAppear {
            if !isEmbed {
                player = AVPlayer(url: streamURL); player?.play()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { withAnimation(.easeOut) { showControls = false } }
        }
        .onDisappear { player?.pause(); player = nil }
        .onTapGesture {
            withAnimation(.easeOut(duration: 0.25)) { showControls.toggle() }
            if showControls { DispatchQueue.main.asyncAfter(deadline: .now() + 5) { withAnimation(.easeOut) { showControls = false } } }
        }
    }

    private var controls: some View {
        VStack(spacing: 0) {
            HStack {
                Button { player?.pause(); dismiss() } label: {
                    Image(systemName: "xmark").font(.headline).foregroundColor(.white).padding(10)
                        .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 10))
                }
                Spacer()
            }.padding(12)
            Spacer()
            if !isEmbed {
                VStack(spacing: 10) {
                    HStack {
                        Text(fmt(currentTime)).font(.caption).foregroundColor(.white)
                        Slider(value: $currentTime, in: 0...totalTime) { ed in
                            if !ed { player?.seek(to: CMTime(seconds: currentTime, preferredTimescale: 600)) }
                        }.tint(.accentGold)
                        Text(fmt(totalTime)).font(.caption).foregroundColor(.white)
                    }.padding(.horizontal, 16)
                    HStack(spacing: 36) {
                        Button { player?.seek(to: CMTime(seconds: max(0, currentTime - 10), preferredTimescale: 600)) } label: {
                            Image(systemName: "gobackward.10").font(.title2).foregroundColor(.white)
                        }
                        Button {
                            isPlaying ? player?.pause() : player?.play(); isPlaying.toggle()
                        } label: {
                            Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .font(.system(size: 50)).foregroundColor(.white)
                        }
                        Button { player?.seek(to: CMTime(seconds: min(totalTime, currentTime + 10), preferredTimescale: 600)) } label: {
                            Image(systemName: "goforward.10").font(.title2).foregroundColor(.white)
                        }
                    }
                }.padding(.bottom, 30).padding(.top, 16)
                    .background(LinearGradient(colors: [.clear, .black.opacity(0.8)], startPoint: .top, endPoint: .bottom))
            }
        }
    }

    private func fmt(_ t: Double) -> String { let m = Int(t)/60; let s = Int(t)%60; return "\(m):\(String(format: "%02d", s))" }
}

struct WebView: UIViewRepresentable {
    let url: URL
    func makeUIView(context: Context) -> WKWebView {
        let c = WKWebViewConfiguration(); c.allowsInlineMediaPlayback = true; c.mediaTypesRequiringUserActionForPlayback = []
        let w = WKWebView(frame: .zero, configuration: c); w.scrollView.isScrollEnabled = false; w.backgroundColor = .black
        w.load(URLRequest(url: url)); return w
    }
    func updateUIView(_ w: WKWebView, context: Context) {}
}

struct VideoPlayerWrap: UIViewControllerRepresentable {
    let player: AVPlayer
    @Binding var isPlaying: Bool
    @Binding var currentTime: Double
    @Binding var totalTime: Double

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let c = AVPlayerViewController(); c.player = player; c.showsPlaybackControls = false; c.videoGravity = .resizeAspectFill
        context.coordinator.addObserver(player: player)
        return c
    }
    func updateUIViewController(_ c: AVPlayerViewController, context: Context) {
        isPlaying ? c.player?.play() : c.player?.pause()
    }
    func makeCoordinator() -> Coordinator { Coordinator(self) }

    class Coordinator: NSObject {
        let p: VideoPlayerWrap; var obs: Any?
        init(_ p: VideoPlayerWrap) { self.p = p }
        func addObserver(player: AVPlayer) {
            guard let item = player.currentItem else { return }
            p.totalTime = item.duration.seconds
            obs = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: .main) { t in
                self.p.currentTime = t.seconds; self.p.totalTime = item.duration.seconds
            }
        }
        deinit { if let o = obs { p.player.removeTimeObserver(o) } }
    }
}
