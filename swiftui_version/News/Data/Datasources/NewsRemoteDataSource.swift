import Foundation

class NewsRemoteDataSource {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func getTopHeadlines(
        country: String = "us",
        category: String? = nil,
        q: String? = nil,
        page: Int = 1,
        pageSize: Int = 20
    ) async throws -> (articles: [ArticleModel], totalResults: Int) {
        var params: [String: String] = [
            "country": country,
            "page": String(page),
            "pageSize": String(pageSize)
        ]
        
        if let category = category, !category.isEmpty {
            params["category"] = category
        }
        if let q = q, !q.isEmpty {
            params["q"] = q
        }
        
        AppLogger.shared.debug("NewsRemoteDataSource.getTopHeadlines params: \(params)")
        
        let response: TopHeadlinesResponse = try await networkClient.get(
            endpoint: "/top-headlines",
            queryParameters: params
        )
        
        let articles = response.articles.map { $0 as ArticleModel }
        return (articles: articles, totalResults: response.totalResults)
    }
}
