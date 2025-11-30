import Foundation

/// Remote data source for fetching news from the News API
class NewsRemoteDataSource {
    private let httpClient: HttpClient
    
    init(httpClient: HttpClient) {
        self.httpClient = httpClient
    }
    
    func getTopHeadlines(
        country: String,
        category: String?,
        query: String?,
        page: Int,
        pageSize: Int
    ) async throws -> (articles: [ArticleModel], totalResults: Int) {
        var queryParams: [String: String] = [
            "country": country,
            "page": String(page),
            "pageSize": String(pageSize)
        ]
        
        if let category = category, !category.isEmpty {
            queryParams["category"] = category
        }
        if let query = query, !query.isEmpty {
            queryParams["q"] = query
        }
        
        AppLogger.d("NewsRemoteDataSource: Fetching top headlines with params: \(queryParams)")
        
        let response: NewsApiResponse = try await httpClient.get(
            endpoint: "/top-headlines",
            queryParameters: queryParams
        )
        
        AppLogger.d("NewsRemoteDataSource: Received \(response.articles.count) articles")
        
        return (articles: response.articles, totalResults: response.totalResults)
    }
}
