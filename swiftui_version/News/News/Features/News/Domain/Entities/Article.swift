import Foundation

/// Domain entity representing a news article
struct Article: Identifiable, Hashable, Equatable {
    let id: UUID
    let sourceName: String?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: Date?
    
    init(
        id: UUID = UUID(),
        sourceName: String? = nil,
        author: String? = nil,
        title: String? = nil,
        description: String? = nil,
        url: String? = nil,
        urlToImage: String? = nil,
        publishedAt: Date? = nil
    ) {
        self.id = id
        self.sourceName = sourceName
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Article, rhs: Article) -> Bool {
        lhs.id == rhs.id
    }
}
