import SwiftUI

extension View {
    func glassBackground(cornerRadius: CGFloat = 16, opacity: CGFloat = 0.7) -> some View {
        self.background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: cornerRadius)
        )
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(.white.opacity(0.15), lineWidth: 1)
        )
    }

    func glow(color: Color = .accentColor, radius: CGFloat = 20) -> some View {
        self.shadow(color: color.opacity(0.5), radius: radius)
    }

    func shimmer(active: Bool = true) -> some View {
        self.modifier(ShimmerModifier(isActive: active))
    }
}

extension Color {
    static let accentGold = Color(red: 0.93, green: 0.76, blue: 0.18)
    static let darkBackground = Color(red: 0.05, green: 0.05, blue: 0.08)
    static let cardBackground = Color(red: 0.12, green: 0.12, blue: 0.17)
    static let glassStroke = Color.white.opacity(0.15)
    static let textSecondary = Color.white.opacity(0.6)
    static let ratingGold = Color(red: 0.95, green: 0.75, blue: 0.15)
}

// MARK: - Shimmer Effect
struct ShimmerModifier: ViewModifier {
    let isActive: Bool
    @State private var phase: CGFloat = -1

    func body(content: Content) -> some View {
        content
            .overlay(isActive ? shimmerOverlay : nil)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var shimmerOverlay: some View {
        GeometryReader { geo in
            LinearGradient(
                gradient: Gradient(colors: [
                    .clear,
                    .white.opacity(0.1),
                    .white.opacity(0.3),
                    .white.opacity(0.1),
                    .clear
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: geo.size.width * 2)
            .offset(x: geo.size.width * phase)
            .onAppear {
                withAnimation(.linear(duration: 1.8).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
        }
    }
}

// MARK: - Rounded Corner Helper
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
