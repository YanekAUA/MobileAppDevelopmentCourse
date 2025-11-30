import SwiftUI

/// Main news list view with search and infinite scroll
struct NewsListView: View {
    @StateObject private var viewModel: NewsViewModel
    @State private var isSearching = false
    @State private var searchText = ""
    @State private var showApiKeyWarning = false
    
    init(getTopHeadlinesUseCase: GetTopHeadlinesUseCase) {
        _viewModel = StateObject(
            wrappedValue: NewsViewModel(getTopHeadlinesUseCase: getTopHeadlinesUseCase)
        )
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if EnvConfig.newsApiKey.isEmpty {
                    // Show API key warning
                    VStack(spacing: 16) {
                        Image(systemName: "key.slash")
                            .font(.system(size: 48))
                            .foregroundColor(.red)
                        
                        Text("API Key Missing")
                            .font(.headline)
                        
                        Text("Please configure the NEWS_API_KEY in your Info.plist file to use the News API.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                } else {
                    // News list content
                    contentView
                }
            }
            .navigationTitle("Top Headlines")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: toggleSearch) {
                        Image(systemName: "magnifyingglass")
                    }
                }
            }
            .task {
                await viewModel.fetchTopHeadlines()
            }
        }
    }
    
    private var contentView: some View {
        ZStack {
            switch viewModel.state {
            case .initial:
                ProgressView()
                
            case .loading:
                VStack(spacing: 16) {
                    ProgressView()
                    Text("Loading articles...")
                }
                
            case .loaded(let articles, _), .loadingMore(let articles, _):
                ScrollViewReader { proxy in
                    List {
                        if isSearching {
                            searchBar
                                .listRowInsets(EdgeInsets())
                        }
                        
                        ForEach(articles) { article in
                            NavigationLink(destination: ArticleDetailView(article: article)) {
                                ArticleTile(article: article)
                                    .id(article.id)
                                    .listRowSeparator(.hidden)
                                    .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                                    .onAppear {
                                        if article.id == articles.last?.id {
                                            Task {
                                                await viewModel.loadMore()
                                            }
                                        }
                                    }
                            }
                        }
                        
                        if case .loadingMore = viewModel.state {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        await viewModel.fetchTopHeadlines(
                            query: searchText.isEmpty ? nil : searchText
                        )
                    }
                }
                
            case .error(let message):
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 48))
                        .foregroundColor(.red)
                    
                    Text("Error Loading Articles")
                        .font(.headline)
                    
                    Text(message)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                    
                    Button(action: {
                        Task {
                            await viewModel.fetchTopHeadlines(
                                query: searchText.isEmpty ? nil : searchText
                            )
                        }
                    }) {
                        Text("Retry")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search articles", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .onChange(of: searchText) { oldValue, newValue in
                    let trimmed = newValue.trimmingCharacters(in: .whitespaces)
                    Task {
                        try? await Task.sleep(for: .milliseconds(500))
                        await viewModel.fetchTopHeadlines(
                            query: trimmed.isEmpty ? nil : trimmed
                        )
                    }
                }
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                    Task {
                        await viewModel.fetchTopHeadlines()
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
    }
    
    private func toggleSearch() {
        isSearching.toggle()
        if !isSearching {
            searchText = ""
            Task {
                await viewModel.fetchTopHeadlines()
            }
        }
    }
}

#Preview {
    let useCase = GetTopHeadlinesUseCase(
        repository: NewsRepositoryImpl(
            remoteDataSource: NewsRemoteDataSource(
                httpClient: HttpClient()
            )
        )
    )
    NewsListView(getTopHeadlinesUseCase: useCase)
}
