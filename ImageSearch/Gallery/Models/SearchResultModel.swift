import Foundation

public struct SearchResult: Codable, Hashable {
    let total, totalHits: Int
    let hits: [Photo]
}

struct Photo: Codable, Hashable {
    var largeImageURL: String
}
