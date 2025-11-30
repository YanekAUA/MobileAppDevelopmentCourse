import Foundation

class GetTopHeadlinesUseCase {
    private let repository: NewsRepository
    
    init(repository: NewsRepository) {
        self.repository = repository
    }
    
    func call(
        country: String = "us",
        category: String? = nil,
        q: String? = nil,
        page: Int = 1,
        pageSize: Int = 20
    ) async throws -> ArticlesPage {
        AppLogger.shared.debug(
            "GetTopHeadlines: calling repository with country=\(country), category=\(category ?? "nil"), q=\(q ?? "nil")"
        )
        return try await repository.getTopHeadlines(
            country: country,
            category: category,
            q: q,
            page: page,
            pageSize: pageSize
        )
    }
}
