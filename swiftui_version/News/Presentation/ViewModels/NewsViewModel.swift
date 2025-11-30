import Foundation

// News UI State
enum NewsUIState {
    case initial
    case loading
    case loaded(articles: [Article], hasReachedMax: Bool, isLoadingMore: Bool)
    case error(String)
}

// News ViewModel - Observable for SwiftUI
@MainActor
class NewsViewModel: ObservableObject {
    @Published var state: NewsUIState = .initial
    @Published var searchText: String = ""
    @Published var selectedCategory: String? = nil
    @Published var localSearchResults: [Article]? = nil
    
    private var currentPage = 1
    private var hasReachedMax = false
    private var isFetchingMore = false
    private var totalResults = 0
    private let pageSize = 20
    
    private let useCase: GetTopHeadlinesUseCase
    private let connectivityManager: ConnectivityManager
    
    init(
        useCase: GetTopHeadlinesUseCase = DIContainer.shared.resolve(GetTopHeadlinesUseCase.self),
        connectivityManager: ConnectivityManager = DIContainer.shared.resolve(ConnectivityManager.self)
    ) {
        self.useCase = useCase
        self.connectivityManager = connectivityManager
    }
    
    // MARK: - Public Methods
    
    func fetchTopHeadlines(category: String? = nil, q: String? = nil) {
        Task {
            state = .loading
            currentPage = 1
            hasReachedMax = false
            totalResults = 0
            
            AppLogger.shared.debug(
                "NewsViewModel: FetchTopHeadlines fired, category: \(category ?? "nil"), q: \(q ?? "nil")"
            )
            
            do {
                let result = try await useCase.call(
                    country: "us",
                    category: category,
                    q: q,
                    page: currentPage,
                    pageSize: pageSize
                )
                
                totalResults = result.totalResults
                let articles = result.articles
                AppLogger.shared.debug(
                    "NewsViewModel: Received \(articles.count) articles for page=\(currentPage) (totalResults=\(totalResults))"
                )
                
                if articles.count >= totalResults {
                    hasReachedMax = true
                }
                
                state = .loaded(articles: articles, hasReachedMax: hasReachedMax, isLoadingMore: false)
            } catch {
                AppLogger.shared.error("NewsViewModel: Error while fetching headlines -> \(error.localizedDescription)")
                state = .error(error.localizedDescription)
            }
        }
    }
    
    func loadMoreHeadlines(category: String? = nil, q: String? = nil) {
        guard case .loaded(let currentArticles, let maxReached, _) = state else { return }
        guard !maxReached && !isFetchingMore else { return }
        
        AppLogger.shared.debug("NewsViewModel: LoadMoreHeadlines fired")
        
        Task {
            isFetchingMore = true
            state = .loaded(articles: currentArticles, hasReachedMax: maxReached, isLoadingMore: true)
            
            do {
                let nextPage = currentPage + 1
                let result = try await useCase.call(
                    country: "us",
                    category: category,
                    q: q,
                    page: nextPage,
                    pageSize: pageSize
                )
                
                let newArticles = result.articles
                totalResults = result.totalResults
                AppLogger.shared.debug(
                    "NewsViewModel: Received \(newArticles.count) articles for page=\(nextPage)"
                )
                
                if newArticles.isEmpty {
                    hasReachedMax = true
                    state = .loaded(articles: currentArticles, hasReachedMax: true, isLoadingMore: false)
                } else {
                    currentPage = nextPage
                    let allArticles = currentArticles + newArticles
                    if allArticles.count >= totalResults {
                        hasReachedMax = true
                    }
                    state = .loaded(articles: allArticles, hasReachedMax: hasReachedMax, isLoadingMore: false)
                }
            } catch {
                AppLogger.shared.error("NewsViewModel: Error while loading more headlines -> \(error.localizedDescription)")
                state = .error(error.localizedDescription)
            }
            
            isFetchingMore = false
        }
    }
    
    func performSearch(query: String?) async {
        let hasConnection = connectivityManager.hasInternetConnection()
        
        if !hasConnection {
            if case .loaded(let loadedArticles, _, _) = state {
                if let q = query, !q.isEmpty {
                    let lq = q.lowercased()
                    localSearchResults = loadedArticles.filter { article in
                        let title = (article.title ?? "").lowercased()
                        let desc = (article.description ?? "").lowercased()
                        return title.contains(lq) || desc.contains(lq)
                    }
                } else {
                    localSearchResults = nil
                }
            } else {
                localSearchResults = []
            }
            return
        }
        
        // Perform API search
        localSearchResults = nil
        let q = query.flatMap { $0.trimmingCharacters(in: .whitespaces).isEmpty ? nil : $0.trimmingCharacters(in: .whitespaces) }
        fetchTopHeadlines(category: selectedCategory, q: q)
    }
    
    func refresh(category: String? = nil, q: String? = nil) {
        fetchTopHeadlines(category: category, q: q)
    }
}
