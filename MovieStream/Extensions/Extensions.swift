import SwiftUI

extension View {
    func glass(cornerRadius: CGFloat = 16) -> some View {
        self.background(.thickMaterial, in: RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(Color.white.opacity(0.2), lineWidth: 1))
            .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
    }

    func glow(color: Color = .accentGold, radius: CGFloat = 15) -> some View {
        self.shadow(color: color.opacity(0.4), radius: radius)
    }

    func shimmer(active: Bool = false) -> some View {
        self.overlay(active ? Color.black.opacity(0.3).cornerRadius(12) : nil)
    }

    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

extension Color {
    static let accentGold = Color(red: 0.95, green: 0.78, blue: 0.22)
    static let bgTop = Color(red: 0.10, green: 0.08, blue: 0.18)
    static let bgBot = Color(red: 0.04, green: 0.04, blue: 0.07)
    static let cardBg = Color(red: 0.12, green: 0.11, blue: 0.18)
    static let textSec = Color.white.opacity(0.55)
    static let ratingGold = Color(red: 0.95, green: 0.75, blue: 0.15)

    static var bgGradient: LinearGradient {
        LinearGradient(colors: [.bgTop, .bgBot], startPoint: .top, endPoint: .bottom)
    }

    static var accentGradient: LinearGradient {
        LinearGradient(colors: [.accentGold, .orange.opacity(0.7)], startPoint: .leading, endPoint: .trailing)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    func path(in rect: CGRect) -> Path {
        Path(UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath)
    }
}
