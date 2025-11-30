import Foundation

/// Data model for Article with JSON decoding support
struct ArticleModel: Codable {
    let source: SourceModel?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    
    /// Convert to domain entity
    func toDomain() -> Article {
        Article(
            sourceName: source?.name,
            author: author,
            title: title,
            description: description,
            url: url,
            urlToImage: urlToImage,
            publishedAt: ISO8601DateFormatter().date(from: publishedAt ?? "")
        )
    }
    
    enum CodingKeys: String, CodingKey {
        case source, author, title, description, url, urlToImage, publishedAt
    }
}

/// Data model for article source
struct SourceModel: Codable {
    let id: String?
    let name: String?
}

/// Data model for API response containing articles list
struct NewsApiResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [ArticleModel]
}
