import Foundation

struct Article: Identifiable, Codable, Hashable {
    let id: UUID = UUID()
    let sourceName: String?
    let sourceId: String?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: Date?
    let content: String?
    
    enum CodingKeys: String, CodingKey {
        case sourceName = "sourceName"
        case sourceId = "sourceId"
        case author
        case title
        case description
        case url
        case urlToImage
        case publishedAt
        case content
    }
    
    init(
        sourceName: String? = nil,
        sourceId: String? = nil,
        author: String? = nil,
        title: String? = nil,
        description: String? = nil,
        url: String? = nil,
        urlToImage: String? = nil,
        publishedAt: Date? = nil,
        content: String? = nil
    ) {
        self.sourceName = sourceName
        self.sourceId = sourceId
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(url)
    }
    
    static func == (lhs: Article, rhs: Article) -> Bool {
        lhs.title == rhs.title && lhs.url == rhs.url
    }
}
