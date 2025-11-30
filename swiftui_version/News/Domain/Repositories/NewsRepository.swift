import Foundation

protocol NewsRepository {
    func getTopHeadlines(
        country: String,
        category: String?,
        q: String?,
        page: Int,
        pageSize: Int
    ) async throws -> ArticlesPage
}
