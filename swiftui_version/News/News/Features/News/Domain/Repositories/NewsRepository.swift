import Foundation

/// Repository protocol defining the contract for news data operations
protocol NewsRepository {
    func getTopHeadlines(
        country: String,
        category: String?,
        query: String?,
        page: Int,
        pageSize: Int
    ) async throws -> ArticlesPage
}
