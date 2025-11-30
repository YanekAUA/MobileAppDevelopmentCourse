import Foundation

/// Use case for fetching top headline articles
class GetTopHeadlinesUseCase {
    private let repository: NewsRepository
    
    init(repository: NewsRepository) {
        self.repository = repository
    }
    
    func call(
        country: String = "us",
        category: String? = nil,
        query: String? = nil,
        page: Int = 1,
        pageSize: Int = 20
    ) async throws -> ArticlesPage {
        AppLogger.d("GetTopHeadlinesUseCase: calling with country=\(country), category=\(category ?? "nil"), query=\(query ?? "nil"), page=\(page)")
        
        return try await repository.getTopHeadlines(
            country: country,
            category: category,
            query: query,
            page: page,
            pageSize: pageSize
        )
    }
}
