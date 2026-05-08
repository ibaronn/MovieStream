import Foundation
import SwiftUI

// MARK: - Mock Data
struct MockData {
    static let streamingSources: [StreamingSource] = [
        StreamingSource(id: 1, serverName: "Server 1", serverNameArabic: "السيرفر 1", type: .embed, qualities: [
            StreamQuality(label: "720p", url: "https://example.com/stream/720p"),
            StreamQuality(label: "1080p", url: "https://example.com/stream/1080p"),
            StreamQuality(label: "4K", url: "https://example.com/stream/4k"),
        ]),
        StreamingSource(id: 2, serverName: "Server 2", serverNameArabic: "السيرفر 2", type: .direct, qualities: [
            StreamQuality(label: "1080p", url: "https://example.com/stream2/1080p"),
            StreamQuality(label: "4K", url: "https://example.com/stream2/4k"),
        ]),
        StreamingSource(id: 3, serverName: "Server 3", serverNameArabic: "السيرفر 3", type: .hls, qualities: [
            StreamQuality(label: "720p", url: "https://example.com/stream3/720p"),
            StreamQuality(label: "1080p", url: "https://example.com/stream3/1080p"),
        ]),
    ]

    static let movies: [Movie] = [
        Movie(id: 1, title: "The Shawshank Redemption", arabicTitle: "الخلاص من شوشنك", overview: "Two imprisoned men bond over years, finding solace and redemption.", arabicOverview: "سجينان يتبادلان المشاعر على مر السنين ويجدان الخلاص.", posterURL: "https://picsum.photos/seed/m1/400/600", backdropURL: "https://picsum.photos/seed/b1/1200/600", year: 1994, rating: 9.3, genres: [.drama], isDubbed: true, isSubtitled: true, qualities: ["720p", "1080p", "4K"], duration: 142, cast: ["Tim Robbins", "Morgan Freeman"], director: "Frank Darabont", trailerURL: nil),
        Movie(id: 2, title: "Inception", arabicTitle: "استهلال", overview: "A thief who steals secrets through dream-sharing technology.", arabicOverview: "لص يسرق الأسرار عبر تقنية مشاركة الأحلام.", posterURL: "https://picsum.photos/seed/m2/400/600", backdropURL: "https://picsum.photos/seed/b2/1200/600", year: 2010, rating: 8.8, genres: [.action, .sciFi, .thriller], isDubbed: true, isSubtitled: true, qualities: ["720p", "1080p", "4K"], duration: 148, cast: ["Leonardo DiCaprio", "Joseph Gordon-Levitt"], director: "Christopher Nolan", trailerURL: nil),
        Movie(id: 3, title: "The Dark Knight", arabicTitle: "فارس الظلام", overview: "Batman faces the Joker's chaos in Gotham.", arabicOverview: "باتمان يواجه فوضى الجوكر في جوثام.", posterURL: "https://picsum.photos/seed/m3/400/600", backdropURL: "https://picsum.photos/seed/b3/1200/600", year: 2008, rating: 9.0, genres: [.action, .crime, .drama], isDubbed: true, isSubtitled: true, qualities: ["720p", "1080p", "4K"], duration: 152, cast: ["Christian Bale", "Heath Ledger"], director: "Christopher Nolan", trailerURL: nil),
        Movie(id: 4, title: "Interstellar", arabicTitle: "بين النجوم", overview: "Explorers travel through a wormhole to save humanity.", arabicOverview: "مستكشفون يسافرون عبر ثقب دودي لإنقاذ البشرية.", posterURL: "https://picsum.photos/seed/m4/400/600", backdropURL: "https://picsum.photos/seed/b4/1200/600", year: 2014, rating: 8.7, genres: [.sciFi, .drama, .adventure], isDubbed: true, isSubtitled: true, qualities: ["1080p", "4K"], duration: 169, cast: ["Matthew McConaughey", "Anne Hathaway"], director: "Christopher Nolan", trailerURL: nil),
        Movie(id: 5, title: "Spirited Away", arabicTitle: "المخطوفة", overview: "A girl wanders into a world of spirits.", arabicOverview: "فتاة تتوه في عالم الأرواح.", posterURL: "https://picsum.photos/seed/m5/400/600", backdropURL: "https://picsum.photos/seed/b5/1200/600", year: 2001, rating: 8.6, genres: [.animation, .fantasy, .adventure], isDubbed: true, isSubtitled: true, qualities: ["720p", "1080p"], duration: 125, cast: ["Rumi Hiiragi", "Miyu Irino"], director: "Hayao Miyazaki", trailerURL: nil),
        Movie(id: 6, title: "Parasite", arabicTitle: "طفيلي", overview: "A poor family schemes to work for a wealthy family.", arabicOverview: "عائلة فقيرة تخطط للعمل لدى عائلة ثرية.", posterURL: "https://picsum.photos/seed/m6/400/600", backdropURL: "https://picsum.photos/seed/b6/1200/600", year: 2019, rating: 8.5, genres: [.thriller, .drama, .comedy], isDubbed: true, isSubtitled: true, qualities: ["720p", "1080p", "4K"], duration: 132, cast: ["Song Kang-ho", "Lee Sun-kyun"], director: "Bong Joon-ho", trailerURL: nil),
        Movie(id: 7, title: "The Matrix", arabicTitle: "الماتريكس", overview: "A hacker discovers the truth about reality.", arabicOverview: "هاكر يكتشف حقيقة الواقع.", posterURL: "https://picsum.photos/seed/m7/400/600", backdropURL: "https://picsum.photos/seed/b7/1200/600", year: 1999, rating: 8.7, genres: [.action, .sciFi], isDubbed: true, isSubtitled: true, qualities: ["720p", "1080p", "4K"], duration: 136, cast: ["Keanu Reeves", "Laurence Fishburne"], director: "The Wachowskis", trailerURL: nil),
        Movie(id: 8, title: "The Godfather", arabicTitle: "العراب", overview: "A crime dynasty transfers power to its son.", arabicOverview: "عائلة جريمة تنقل السلطة لابنها.", posterURL: "https://picsum.photos/seed/m8/400/600", backdropURL: "https://picsum.photos/seed/b8/1200/600", year: 1972, rating: 9.2, genres: [.crime, .drama], isDubbed: true, isSubtitled: true, qualities: ["720p", "1080p"], duration: 175, cast: ["Marlon Brando", "Al Pacino"], director: "Francis Ford Coppola", trailerURL: nil),
        Movie(id: 9, title: "Pulp Fiction", arabicTitle: "خيال رخيص", overview: "Interwoven stories of crime in Los Angeles.", arabicOverview: "قصص متشابكة من الجريمة في لوس أنجلوس.", posterURL: "https://picsum.photos/seed/m9/400/600", backdropURL: "https://picsum.photos/seed/b9/1200/600", year: 1994, rating: 8.9, genres: [.crime, .drama, .thriller], isDubbed: true, isSubtitled: true, qualities: ["720p", "1080p"], duration: 154, cast: ["John Travolta", "Samuel L. Jackson"], director: "Quentin Tarantino", trailerURL: nil),
        Movie(id: 10, title: "Fight Club", arabicTitle: "نادي القتال", overview: "An insomniac and a soap salesman start an underground fight club.", arabicOverview: "مصاب بالأرق وبائع صابون يؤسسان نادي قتال سري.", posterURL: "https://picsum.photos/seed/m10/400/600", backdropURL: "https://picsum.photos/seed/b10/1200/600", year: 1999, rating: 8.8, genres: [.drama, .thriller], isDubbed: true, isSubtitled: true, qualities: ["720p", "1080p", "4K"], duration: 139, cast: ["Brad Pitt", "Edward Norton"], director: "David Fincher", trailerURL: nil),
        Movie(id: 11, title: "Breaking Bad", arabicTitle: "اختلال ضال", overview: "A chemistry teacher turns to cooking meth after a cancer diagnosis.", arabicOverview: "مدرس كيمياء يتحول لصناعة الميث بعد تشخيص إصابته بالسرطان.", posterURL: "https://picsum.photos/seed/m11/400/600", backdropURL: "https://picsum.photos/seed/b11/1200/600", year: 2008, rating: 9.5, genres: [.crime, .drama, .thriller], isDubbed: true, isSubtitled: true, qualities: ["720p", "1080p", "4K"], duration: 49, cast: ["Bryan Cranston", "Aaron Paul"], director: "Vince Gilligan", trailerURL: nil),
        Movie(id: 12, title: "Game of Thrones", arabicTitle: "صراع العروش", overview: "Noble families fight for control of the Iron Throne.", arabicOverview: "عائلات نبيلة تتصارع للسيطرة على العرش الحديدي.", posterURL: "https://picsum.photos/seed/m12/400/600", backdropURL: "https://picsum.photos/seed/b12/1200/600", year: 2011, rating: 9.2, genres: [.fantasy, .adventure, .drama], isDubbed: true, isSubtitled: true, qualities: ["720p", "1080p", "4K"], duration: 57, cast: ["Emilia Clarke", "Kit Harington"], director: "David Benioff", trailerURL: nil),
        Movie(id: 13, title: "Money Heist", arabicTitle: "سرقة المال", overview: "A criminal mastermind plans the biggest heist in history.", arabicOverview: "عقل إجرامي مدبر يخطط لأكبر سرقة في التاريخ.", posterURL: "https://picsum.photos/seed/m13/400/600", backdropURL: "https://picsum.photos/seed/b13/1200/600", year: 2017, rating: 8.3, genres: [.action, .crime, .thriller], isDubbed: true, isSubtitled: true, qualities: ["720p", "1080p", "4K"], duration: 50, cast: ["Úrsula Corberó", "Álvaro Morte"], director: "Álex Pina", trailerURL: nil),
        Movie(id: 14, title: "Stranger Things", arabicTitle: "أشياء غريبة", overview: "Kids uncover supernatural mysteries in a small town.", arabicOverview: "أطفال يكشفون ألغازاً خارقة للطبيعة في بلدة صغيرة.", posterURL: "https://picsum.photos/seed/m14/400/600", backdropURL: "https://picsum.photos/seed/b14/1200/600", year: 2016, rating: 8.7, genres: [.fantasy, .horror, .mystery], isDubbed: true, isSubtitled: true, qualities: ["720p", "1080p", "4K"], duration: 51, cast: ["Millie Bobby Brown", "Finn Wolfhard"], director: "The Duffer Brothers", trailerURL: nil),
        Movie(id: 15, title: "The Lion King", arabicTitle: "الأسد الملك", overview: "A lion prince flees his kingdom after his father's murder.", arabicOverview: "أمير أسد يهرب من مملكته بعد مقتل والده.", posterURL: "https://picsum.photos/seed/m15/400/600", backdropURL: "https://picsum.photos/seed/b15/1200/600", year: 1994, rating: 8.5, genres: [.animation, .adventure, .drama], isDubbed: true, isSubtitled: true, qualities: ["720p", "1080p", "4K"], duration: 88, cast: ["Matthew Broderick", "Jeremy Irons"], director: "Roger Allers", trailerURL: nil),
        Movie(id: 16, title: "Gladiator", arabicTitle: "المصارع", overview: "A betrayed Roman general becomes a gladiator seeking revenge.", arabicOverview: "جنرال روماني مغدور يصبح مصارعاً يسعى للانتقام.", posterURL: "https://picsum.photos/seed/m16/400/600", backdropURL: "https://picsum.photos/seed/b16/1200/600", year: 2000, rating: 8.5, genres: [.action, .adventure, .drama], isDubbed: true, isSubtitled: true, qualities: ["720p", "1080p", "4K"], duration: 155, cast: ["Russell Crowe", "Joaquin Phoenix"], director: "Ridley Scott", trailerURL: nil),
        Movie(id: 17, title: "The Witcher", arabicTitle: "الساحر", overview: "A mutated monster hunter struggles to find his place in a world.", arabicOverview: "صياد وحوش متحور يكافح ليجد مكانه في العالم.", posterURL: "https://picsum.photos/seed/m17/400/600", backdropURL: "https://picsum.photos/seed/b17/1200/600", year: 2019, rating: 8.2, genres: [.fantasy, .action, .adventure], isDubbed: true, isSubtitled: true, qualities: ["720p", "1080p", "4K"], duration: 60, cast: ["Henry Cavill", "Anya Chalotra"], director: "Lauren Schmidt", trailerURL: nil),
        Movie(id: 18, title: "Avengers: Endgame", arabicTitle: "المنتقمون: نهاية اللعبة", overview: "The Avengers assemble for one final stand against Thanos.", arabicOverview: "المنتقمون يتجمعون لموقعة أخيرة ضد ثانوس.", posterURL: "https://picsum.photos/seed/m18/400/600", backdropURL: "https://picsum.photos/seed/b18/1200/600", year: 2019, rating: 8.4, genres: [.action, .adventure, .sciFi], isDubbed: true, isSubtitled: true, qualities: ["1080p", "4K"], duration: 181, cast: ["Robert Downey Jr.", "Chris Evans"], director: "Anthony Russo", trailerURL: nil),
        Movie(id: 19, title: "The Last of Us", arabicTitle: "آخرنا", overview: "A smuggler escorts a girl across a post-apocalyptic America.", arabicOverview: "مهرب يرافق فتاة عبر أمريكا ما بعد نهاية العالم.", posterURL: "https://picsum.photos/seed/m19/400/600", backdropURL: "https://picsum.photos/seed/b19/1200/600", year: 2023, rating: 8.8, genres: [.drama, .horror, .adventure], isDubbed: true, isSubtitled: true, qualities: ["720p", "1080p", "4K"], duration: 60, cast: ["Pedro Pascal", "Bella Ramsey"], director: "Craig Mazin", trailerURL: nil),
        Movie(id: 20, title: "Squid Game", arabicTitle: "لعبة الحبار", overview: "Contestants play deadly children's games for a cash prize.", arabicOverview: "متنافسون يلعبون ألعاب أطفال مميتة لجائزة مالية.", posterURL: "https://picsum.photos/seed/m20/400/600", backdropURL: "https://picsum.photos/seed/b20/1200/600", year: 2021, rating: 8.0, genres: [.thriller, .drama, .mystery], isDubbed: true, isSubtitled: true, qualities: ["720p", "1080p", "4K"], duration: 55, cast: ["Lee Jung-jae", "Park Hae-soo"], director: "Hwang Dong-hyuk", trailerURL: nil),
        Movie(id: 21, title: "Dune", arabicTitle: "الكثيب", overview: "A noble family becomes embroiled in a war for control of the galaxy's most valuable asset.", arabicOverview: "عائلة نبيلة تتورط في حرب للسيطرة على أثمن مورد في المجرة.", posterURL: "https://picsum.photos/seed/m21/400/600", backdropURL: "https://picsum.photos/seed/b21/1200/600", year: 2021, rating: 8.0, genres: [.sciFi, .adventure, .drama], isDubbed: true, isSubtitled: true, qualities: ["1080p", "4K"], duration: 155, cast: ["Timothée Chalamet", "Zendaya"], director: "Denis Villeneuve", trailerURL: nil),
        Movie(id: 22, title: "Joker", arabicTitle: "الجوكر", overview: "A failed comedian descends into madness and becomes the Joker.", arabicOverview: "كوميدي فاشل ينحدر للجنون ويصبح الجوكر.", posterURL: "https://picsum.photos/seed/m22/400/600", backdropURL: "https://picsum.photos/seed/b22/1200/600", year: 2019, rating: 8.4, genres: [.crime, .drama, .thriller], isDubbed: true, isSubtitled: true, qualities: ["720p", "1080p", "4K"], duration: 122, cast: ["Joaquin Phoenix", "Robert De Niro"], director: "Todd Phillips", trailerURL: nil),
        Movie(id: 23, title: "Oppenheimer", arabicTitle: "أوبنهايمر", overview: "The story of the man who created the atomic bomb.", arabicOverview: "قصة الرجل الذي صنع القنبلة الذرية.", posterURL: "https://picsum.photos/seed/m23/400/600", backdropURL: "https://picsum.photos/seed/b23/1200/600", year: 2023, rating: 8.4, genres: [.drama, .historical, .thriller], isDubbed: true, isSubtitled: true, qualities: ["1080p", "4K"], duration: 180, cast: ["Cillian Murphy", "Robert Downey Jr."], director: "Christopher Nolan", trailerURL: nil),
        Movie(id: 24, title: "The Boys", arabicTitle: "الأولاد", overview: "Vigilantes take on corrupt superheroes.", arabicOverview: " vigilante يواجهون أبطالاً خارقين فاسدين.", posterURL: "https://picsum.photos/seed/m24/400/600", backdropURL: "https://picsum.photos/seed/b24/1200/600", year: 2019, rating: 8.7, genres: [.action, .crime, .comedy], isDubbed: true, isSubtitled: true, qualities: ["720p", "1080p", "4K"], duration: 60, cast: ["Karl Urban", "Jack Quaid"], director: "Eric Kripke", trailerURL: nil),
    ]
}

// MARK: - APIService
class APIService {
    private var baseURL: String {
        UserDefaults.standard.string(forKey: "api_base_url") ?? "https://api.example.com"
    }

    private var isConfigured: Bool {
        !baseURL.contains("example.com") && !baseURL.isEmpty
    }

    func fetchMovies(page: Int = 1) async throws -> MovieResponse {
        if !isConfigured { throw APIError.notConfigured }
        guard let url = URL(string: "\(baseURL)/movies?page=\(page)") else { throw APIError.invalidURL }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(MovieResponse.self, from: data)
    }

    func fetchMovieDetail(id: Int) async throws -> Movie {
        if !isConfigured { throw APIError.notConfigured }
        guard let url = URL(string: "\(baseURL)/movies/\(id)") else { throw APIError.invalidURL }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Movie.self, from: data)
    }

    func fetchStreamingSources(movieId: Int) async throws -> [StreamingSource] {
        if !isConfigured { throw APIError.notConfigured }
        guard let url = URL(string: "\(baseURL)/movies/\(movieId)/sources") else { throw APIError.invalidURL }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([StreamingSource].self, from: data)
    }

    func searchMovies(query: String) async throws -> [Movie] {
        if !isConfigured { throw APIError.notConfigured }
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        guard let url = URL(string: "\(baseURL)/search?q=\(encoded)") else { throw APIError.invalidURL }
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(MovieResponse.self, from: data)
        return response.movies
    }
}

enum APIError: LocalizedError {
    case invalidURL
    case networkError(String)
    case decodingError
    case notConfigured

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "رابط غير صالح"
        case .networkError(let msg): return "خطأ في الشبكة: \(msg)"
        case .decodingError: return "خطأ في فك الترميز"
        case .notConfigured: return "لم يتم إعداد API بعد. اذهب إلى الإعدادات وأدخل رابط السيرفر"
        }
    }
}
