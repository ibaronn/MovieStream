import Foundation
import SwiftUI

// MARK: - Mock Data
struct MockData {
    static let streamingSources: [StreamingSource] = [
        StreamingSource(id: 1, serverName: "Server 1", serverNameArabic: "السيرفر 1", type: .embed, qualities: [
            StreamQuality(label: "720p", url: "https://example.com/stream/720p"),
            StreamQuality(label: "1080p", url: "https://example.com/stream/1080p"),
        ]),
        StreamingSource(id: 2, serverName: "Server 2", serverNameArabic: "السيرفر 2", type: .direct, qualities: [
            StreamQuality(label: "1080p", url: "https://example.com/stream2/1080p"),
            StreamQuality(label: "4K", url: "https://example.com/stream2/4k"),
        ]),
    ]

    static let movies: [Movie] = [
        Movie(id: 1, title: "Inception", arabicTitle: "استهلال", overview: "A thief who steals corporate secrets through dream-sharing technology is given the task of planting an idea.", arabicOverview: "لص يسرق أسرار الشركات من خلال تقنية مشاركة الأحلام يُكلف بمهمة زرع فكرة في عقل شخص.", posterURL: "https://picsum.photos/seed/movie1/400/600", backdropURL: "https://picsum.photos/seed/bg1/1200/600", year: 2010, rating: 8.8, genres: [.action, .sciFi, .thriller], isDubbed: true, isSubtitled: true, qualities: ["720p", "1080p", "4K"], duration: 148, cast: ["Leonardo DiCaprio", "Joseph Gordon-Levitt", "Elliot Page"], director: "Christopher Nolan", trailerURL: nil),
        Movie(id: 2, title: "The Dark Knight", arabicTitle: "فارس الظلام", overview: "When the menace known as the Joker wreaks havoc on Gotham, Batman must accept one of the greatest tests.", arabicOverview: "عندما يزرع الجوكر الفوضى في جوثام، على باتمان أن يواجه أحد أعظم اختباراته.", posterURL: "https://picsum.photos/seed/movie2/400/600", backdropURL: "https://picsum.photos/seed/bg2/1200/600", year: 2008, rating: 9.0, genres: [.action, .crime, .drama], isDubbed: true, isSubtitled: true, qualities: ["720p", "1080p", "4K"], duration: 152, cast: ["Christian Bale", "Heath Ledger", "Aaron Eckhart"], director: "Christopher Nolan", trailerURL: nil),
        Movie(id: 3, title: "Interstellar", arabicTitle: "بين النجوم", overview: "A team of explorers travel through a wormhole in space in an attempt to ensure humanity's survival.", arabicOverview: "فريق من المستكشفين يسافرون عبر ثقب دودي في الفضاء لضمان بقاء البشرية.", posterURL: "https://picsum.photos/seed/movie3/400/600", backdropURL: "https://picsum.photos/seed/bg3/1200/600", year: 2014, rating: 8.7, genres: [.sciFi, .drama, .adventure], isDubbed: true, isSubtitled: true, qualities: ["1080p", "4K"], duration: 169, cast: ["Matthew McConaughey", "Anne Hathaway", "Jessica Chastain"], director: "Christopher Nolan", trailerURL: nil),
        Movie(id: 4, title: "Spirited Away", arabicTitle: "المخطوفة", overview: "A young girl wanders into a world of gods and spirits.", arabicOverview: "فتاة صغيرة تتوه في عالم من الآلهة والأرواح.", posterURL: "https://picsum.photos/seed/movie4/400/600", backdropURL: "https://picsum.photos/seed/bg4/1200/600", year: 2001, rating: 8.6, genres: [.animation, .fantasy, .adventure], isDubbed: true, isSubtitled: true, qualities: ["720p", "1080p"], duration: 125, cast: ["Rumi Hiiragi", "Miyu Irino"], director: "Hayao Miyazaki", trailerURL: nil),
        Movie(id: 5, title: "Parasite", arabicTitle: "طفيلي", overview: "A poor family schemes to become employed by a wealthy family.", arabicOverview: "عائلة فقيرة تخطط للعمل لدى عائلة ثرية.", posterURL: "https://picsum.photos/seed/movie5/400/600", backdropURL: "https://picsum.photos/seed/bg5/1200/600", year: 2019, rating: 8.5, genres: [.thriller, .drama, .comedy], isDubbed: true, isSubtitled: true, qualities: ["720p", "1080p", "4K"], duration: 132, cast: ["Song Kang-ho", "Lee Sun-kyun", "Cho Yeo-jeong"], director: "Bong Joon-ho", trailerURL: nil),
        Movie(id: 6, title: "The Matrix", arabicTitle: "الماتريكس", overview: "A computer hacker learns about the true nature of reality.", arabicOverview: "هاكر كمبيوتر يكتشف الحقيقة الواقعية للوجود.", posterURL: "https://picsum.photos/seed/movie6/400/600", backdropURL: "https://picsum.photos/seed/bg6/1200/600", year: 1999, rating: 8.7, genres: [.action, .sciFi], isDubbed: true, isSubtitled: true, qualities: ["720p", "1080p", "4K"], duration: 136, cast: ["Keanu Reeves", "Laurence Fishburne", "Carrie-Anne Moss"], director: "The Wachowskis", trailerURL: nil),
        Movie(id: 7, title: "The Godfather", arabicTitle: "العراب", overview: "The aging patriarch of an organized crime dynasty transfers control to his son.", arabicOverview: "زعيم عائلة جريمة منظمة ينقل السيطرة لابنه.", posterURL: "https://picsum.photos/seed/movie7/400/600", backdropURL: "https://picsum.photos/seed/bg7/1200/600", year: 1972, rating: 9.2, genres: [.crime, .drama], isDubbed: true, isSubtitled: true, qualities: ["720p", "1080p"], duration: 175, cast: ["Marlon Brando", "Al Pacino", "James Caan"], director: "Francis Ford Coppola", trailerURL: nil),
        Movie(id: 8, title: "La Casa de Papel", arabicTitle: "بيت الورق", overview: "A group of robbers attempt the biggest heist in history.", arabicOverview: "مجموعة من اللصوص يحاولون تنفيذ أكبر عملية سرقة في التاريخ.", posterURL: "https://picsum.photos/seed/movie8/400/600", backdropURL: "https://picsum.photos/seed/bg8/1200/600", year: 2017, rating: 8.3, genres: [.action, .crime, .thriller], isDubbed: true, isSubtitled: true, qualities: ["720p", "1080p", "4K"], duration: 50, cast: ["Úrsula Corberó", "Álvaro Morte"], director: "Álex Pina", trailerURL: nil),
    ]
}

// MARK: - APIService
class APIService {
    private let baseURL = "https://api.example.com"

    func fetchMovies(page: Int = 1) async throws -> MovieResponse {
        guard let url = URL(string: "\(baseURL)/movies?page=\(page)") else {
            throw APIError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(MovieResponse.self, from: data)
    }

    func fetchMovieDetail(id: Int) async throws -> Movie {
        guard let url = URL(string: "\(baseURL)/movies/\(id)") else {
            throw APIError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Movie.self, from: data)
    }

    func fetchStreamingSources(movieId: Int) async throws -> [StreamingSource] {
        guard let url = URL(string: "\(baseURL)/movies/\(movieId)/sources") else {
            throw APIError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([StreamingSource].self, from: data)
    }

    func searchMovies(query: String) async throws -> [Movie] {
        guard let url = URL(string: "\(baseURL)/search?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query)") else {
            throw APIError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(MovieResponse.self, from: data)
        return response.movies
    }
}

enum APIError: LocalizedError {
    case invalidURL
    case networkError(String)
    case decodingError

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "رابط غير صالح"
        case .networkError(let msg): return "خطأ في الشبكة: \(msg)"
        case .decodingError: return "خطأ في فك الترميز"
        }
    }
}
