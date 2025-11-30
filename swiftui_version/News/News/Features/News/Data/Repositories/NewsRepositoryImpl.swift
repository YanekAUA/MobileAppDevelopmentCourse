import Foundation

/// Concrete implementation of NewsRepository
class NewsRepositoryImpl: NewsRepository {
    private let remoteDataSource: NewsRemoteDataSource
    
    init(remoteDataSource: NewsRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getTopHeadlines(
        country: String,
        category: String?,
        query: String?,
        page: Int,
        pageSize: Int
    ) async throws -> ArticlesPage {
        let (articleModels, totalResults) = try await remoteDataSource.getTopHeadlines(
            country: country,
            category: category,
            query: query,
            page: page,
            pageSize: pageSize
        )
        
        let articles = articleModels.map { $0.toDomain() }
        
        return ArticlesPage(
            articles: articles,
            totalResults: totalResults
        )
    }
}
