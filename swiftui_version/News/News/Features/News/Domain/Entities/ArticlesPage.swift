import Foundation

/// Domain entity representing a paginated response of articles
struct ArticlesPage: Equatable {
    let articles: [Article]
    let totalResults: Int
    
    static func == (lhs: ArticlesPage, rhs: ArticlesPage) -> Bool {
        lhs.articles == rhs.articles && lhs.totalResults == rhs.totalResults
    }
}
