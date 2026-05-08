import Foundation

struct Movie: Identifiable, Codable, Equatable {
    let id: Int
    let title: String
    let arabicTitle: String?
    let overview: String
    let arabicOverview: String?
    let posterURL: String
    let backdropURL: String
    let year: Int
    let rating: Double
    let genres: [Genre]
    let isDubbed: Bool
    let isSubtitled: Bool
    let qualities: [String]
    let duration: Int
    let cast: [String]
    let director: String
    let trailerURL: String?

    var displayTitle: String { arabicTitle ?? title }
    var displayOverview: String { arabicOverview ?? overview }
}

enum Genre: String, CaseIterable, Identifiable, Codable {
    case all = "الكل"
    case action = "أكشن"
    case adventure = "مغامرة"
    case comedy = "كوميدي"
    case crime = "جريمة"
    case drama = "دراما"
    case fantasy = "خيال"
    case historical = "تاريخي"
    case horror = "رعب"
    case mystery = "غموض"
    case romance = "رومانسي"
    case sciFi = "خيال علمي"
    case thriller = "إثارة"
    case animation = "أنميشن"
    case documentary = "وثائقي"
    case family = "عائلي"
    case war = "حربي"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .all: return "square.grid.2x2"
        case .action: return "figure.walk"
        case .adventure: return "mountain.2"
        case .comedy: return "face.smiling"
        case .crime: return "shield"
        case .drama: return "theatermasks"
        case .fantasy: return "wand.and.stars"
        case .historical: return "building.columns"
        case .horror: return "ghost"
        case .mystery: return "magnifyingglass"
        case .romance: return "heart"
        case .sciFi: return "sparkles"
        case .thriller: return "eye"
        case .animation: return "paintbrush"
        case .documentary: return "book"
        case .family: return "house"
        case .war: return "shield.checkered"
        }
    }

    var englishName: String {
        switch self {
        case .all: return "All"; case .action: return "Action"
        case .adventure: return "Adventure"; case .comedy: return "Comedy"
        case .crime: return "Crime"; case .drama: return "Drama"
        case .fantasy: return "Fantasy"; case .historical: return "Historical"
        case .horror: return "Horror"; case .mystery: return "Mystery"
        case .romance: return "Romance"; case .sciFi: return "Sci-Fi"
        case .thriller: return "Thriller"; case .animation: return "Animation"
        case .documentary: return "Documentary"; case .family: return "Family"
        case .war: return "War"
        }
    }
}

struct StreamingSource: Identifiable, Codable {
    let id: Int
    let serverName: String
    let serverNameArabic: String
    let type: SourceType
    let qualities: [StreamQuality]

    enum SourceType: String, Codable {
        case embed = "embed"
        case direct = "direct"
        case hls = "hls"
    }
}

struct StreamQuality: Codable, Identifiable {
    let label: String
    let url: String
    var id: String { label }
}

struct StreamingServer: Identifiable, Codable {
    let id: Int
    let name: String
    let arabicName: String
    let baseURL: String
    let isActive: Bool
}

struct MovieResponse: Codable {
    let movies: [Movie]
    let totalPages: Int
    let currentPage: Int
}

enum AppTab: String, CaseIterable {
    case home = "house.fill"
    case browse = "square.grid.2x2.fill"
    case search = "magnifyingglass"
    case favorites = "heart.fill"

    var arabicTitle: String {
        switch self {
        case .home: return "الرئيسية"
        case .browse: return "التصنيفات"
        case .search: return "بحث"
        case .favorites: return "المفضلة"
        }
    }
}
