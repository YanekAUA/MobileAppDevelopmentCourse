import Foundation

struct ArticleModel: Codable {
    let source: SourceModel?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: Date?
    let content: String?
    
    func toEntity() -> Article {
        return Article(
            sourceName: source?.name,
            sourceId: source?.id,
            author: author,
            title: title,
            description: description,
            url: url,
            urlToImage: urlToImage,
            publishedAt: publishedAt,
            content: content
        )
    }
}

struct SourceModel: Codable {
    let id: String?
    let name: String?
}
