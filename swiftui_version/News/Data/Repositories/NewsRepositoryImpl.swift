import Foundation

class NewsRepositoryImpl: NewsRepository {
    private let remoteDataSource: NewsRemoteDataSource
    
    init(remoteDataSource: NewsRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getTopHeadlines(
        country: String,
        category: String?,
        q: String?,
        page: Int,
        pageSize: Int
    ) async throws -> ArticlesPage {
        let (models, totalResults) = try await remoteDataSource.getTopHeadlines(
            country: country,
            category: category,
            q: q,
            page: page,
            pageSize: pageSize
        )
        
        let articles = models.map { $0.toEntity() }
        return ArticlesPage(articles: articles, totalResults: totalResults)
    }
}
