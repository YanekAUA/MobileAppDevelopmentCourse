import Foundation

/// State for news list presentation
enum NewsState: Equatable {
    case initial
    case loading
    case loaded(articles: [Article], hasReachedMax: Bool)
    case loadingMore(articles: [Article], hasReachedMax: Bool)
    case error(message: String)
    
    static func == (lhs: NewsState, rhs: NewsState) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial):
            return true
        case (.loading, .loading):
            return true
        case (.loaded(let lhsArticles, let lhsMax), .loaded(let rhsArticles, let rhsMax)):
            return lhsArticles == rhsArticles && lhsMax == rhsMax
        case (.loadingMore(let lhsArticles, let lhsMax), .loadingMore(let rhsArticles, let rhsMax)):
            return lhsArticles == rhsArticles && lhsMax == rhsMax
        case (.error(let lhsMsg), .error(let rhsMsg)):
            return lhsMsg == rhsMsg
        default:
            return false
        }
    }
}

/// ViewModel for managing news list state and business logic
@MainActor
class NewsViewModel: ObservableObject {
    @Published private(set) var state: NewsState = .initial
    
    private let getTopHeadlinesUseCase: GetTopHeadlinesUseCase
    
    private var currentPage = 1
    private let pageSize = 20
    private var hasReachedMax = false
    private var isFetchingMore = false
    private var totalResults = 0
    private var currentCategory: String?
    private var currentQuery: String?
    
    init(getTopHeadlinesUseCase: GetTopHeadlinesUseCase) {
        self.getTopHeadlinesUseCase = getTopHeadlinesUseCase
    }
    
    /// Fetch top headlines (initial load or refresh)
    func fetchTopHeadlines(category: String? = nil, query: String? = nil) async {
        currentPage = 1
        hasReachedMax = false
        currentCategory = category
        currentQuery = query
        
        state = .loading
        
        do {
            let result = try await getTopHeadlinesUseCase.call(
                category: category,
                query: query,
                page: currentPage,
                pageSize: pageSize
            )
            
            AppLogger.d("NewsViewModel: Received \(result.articles.count) articles, total: \(result.totalResults)")
            
            totalResults = result.totalResults
            hasReachedMax = result.articles.count >= totalResults
            
            state = .loaded(articles: result.articles, hasReachedMax: hasReachedMax)
        } catch {
            AppLogger.e("NewsViewModel: Error fetching headlines - \(error.localizedDescription)")
            state = .error(message: error.localizedDescription)
        }
    }
    
    /// Load more articles (pagination)
    func loadMore() async {
        guard !hasReachedMax, !isFetchingMore else {
            return
        }
        
        guard case .loaded(let articles, _) = state else {
            return
        }
        
        isFetchingMore = true
        state = .loadingMore(articles: articles, hasReachedMax: hasReachedMax)
        
        do {
            let nextPage = currentPage + 1
            let result = try await getTopHeadlinesUseCase.call(
                category: currentCategory,
                query: currentQuery,
                page: nextPage,
                pageSize: pageSize
            )
            
            AppLogger.d("NewsViewModel: Received \(result.articles.count) articles for page \(nextPage)")
            
            if result.articles.isEmpty {
                hasReachedMax = true
                state = .loaded(articles: articles, hasReachedMax: true)
            } else {
                currentPage = nextPage
                totalResults = result.totalResults
                var allArticles = articles
                allArticles.append(contentsOf: result.articles)
                
                if allArticles.count >= totalResults {
                    hasReachedMax = true
                }
                
                state = .loaded(articles: allArticles, hasReachedMax: hasReachedMax)
            }
        } catch {
            AppLogger.e("NewsViewModel: Error loading more - \(error.localizedDescription)")
            state = .loaded(articles: articles, hasReachedMax: hasReachedMax)
        }
        
        isFetchingMore = false
    }
}
