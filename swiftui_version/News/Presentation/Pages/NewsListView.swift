import SwiftUI

struct NewsListView: View {
    @StateObject private var viewModel = NewsViewModel()
    @State private var isSearching = false
    @State private var showingFilterDialog = false
    @State private var tempSelectedCategory: String?
    
    private let categories = [
        (label: "All", value: nil as String?),
        (label: "Business", value: "business"),
        (label: "Entertainment", value: "entertainment"),
        (label: "General", value: "general"),
        (label: "Health", value: "health"),
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Main Content
                Group {
                    if EnvConfig.shared.newsApiKey.isEmpty {
                        missingApiKeyView
                    } else {
                        newsListContent
                    }
                }
                
                // Filter Dialog
                if showingFilterDialog {
                    filterDialogView
                }
            }
            .navigationTitle(titleForCategory(viewModel.selectedCategory))
            .navigationBarTitleDisplayMode(.inline)
            .searchable(
                text: $viewModel.searchText,
                prompt: "Search headlines..."
            )
            .onChange(of: viewModel.searchText) { _, newValue in
                Task {
                    let query = newValue.trimmingCharacters(in: .whitespaces)
                    let q = query.isEmpty ? nil : query
                    await viewModel.performSearch(query: q)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Button(action: { showingFilterDialog = true }) {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                        }
                    }
                }
            }
            .onAppear {
                if case .initial = viewModel.state {
                    viewModel.fetchTopHeadlines()
                }
            }
        }
    }
    
    private var missingApiKeyView: some View {
        VStack(spacing: 16) {
            Text("No News API Key")
                .font(.headline)
            Text("Please create a `.env` file with NEWS_API_KEY and rebuild the app.")
                .multilineTextAlignment(.center)
            Button(action: {}) {
                Text("Info")
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
    
    private var newsListContent: some View {
        Group {
            switch viewModel.state {
            case .initial:
                VStack {
                    ProgressView()
                    Text("Loading headlines...")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
            
            case .loading:
                VStack {
                    ProgressView()
                    Text("Loading headlines...")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
            
            case .loaded(let articles, let hasReachedMax, let isLoadingMore):
                let displayedArticles = (viewModel.localSearchResults != nil && !viewModel.searchText.isEmpty)
                    ? viewModel.localSearchResults ?? []
                    : articles
                
                if displayedArticles.isEmpty {
                    VStack {
                        Text(viewModel.searchText.isEmpty ? "No Results Found" : "No results for \"\(viewModel.searchText)\"")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemBackground))
                } else {
                    List {
                        ForEach(displayedArticles, id: \.id) { article in
                            ArticleTileView(article: article)
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                                .onAppear {
                                    if article == displayedArticles.last && !hasReachedMax {
                                        viewModel.loadMoreHeadlines(
                                            category: viewModel.selectedCategory,
                                            q: viewModel.searchText.isEmpty ? nil : viewModel.searchText
                                        )
                                    }
                                }
                        }
                        
                        if isLoadingMore && !hasReachedMax {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        viewModel.refresh(
                            category: viewModel.selectedCategory,
                            q: viewModel.searchText.isEmpty ? nil : viewModel.searchText
                        )
                    }
                }
            
            case .error(let error):
                VStack(spacing: 16) {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                    Button(action: {
                        viewModel.fetchTopHeadlines(
                            category: viewModel.selectedCategory,
                            q: viewModel.searchText.isEmpty ? nil : viewModel.searchText
                        )
                    }) {
                        Text("Retry")
                    }
                    .buttonStyle(.bordered)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
            }
        }
    }
    
    private var filterDialogView: some View {
        ZStack {
            // Dim background
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    showingFilterDialog = false
                }
            
            // Dialog
            VStack(spacing: 16) {
                Text("Filter by Category")
                    .font(.headline)
                
                VStack(spacing: 0) {
                    ForEach(categories, id: \.value) { category in
                        HStack {
                            Button(action: {
                                tempSelectedCategory = category.value
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: tempSelectedCategory == category.value ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(tempSelectedCategory == category.value ? .blue : .gray)
                                    Text(category.label)
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                                .padding(.vertical, 12)
                                .padding(.horizontal, 12)
                            }
                            .buttonStyle(.plain)
                        }
                        if category != categories.last {
                            Divider()
                        }
                    }
                }
                .background(Color(.systemBackground))
                .cornerRadius(8)
                
                HStack(spacing: 12) {
                    Button(action: {
                        showingFilterDialog = false
                    }) {
                        Text("Cancel")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    
                    Button(action: {
                        viewModel.selectedCategory = tempSelectedCategory
                        viewModel.localSearchResults = nil
                        viewModel.fetchTopHeadlines(
                            category: tempSelectedCategory,
                            q: viewModel.searchText.isEmpty ? nil : viewModel.searchText
                        )
                        showingFilterDialog = false
                    }) {
                        Text("Apply")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                Spacer()
            }
            .padding(16)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .padding(16)
        }
        .onAppear {
            tempSelectedCategory = viewModel.selectedCategory
        }
    }
    
    private func titleForCategory(_ category: String?) -> String {
        switch category {
        case "business":
            return "Top Headlines • Business"
        case "entertainment":
            return "Top Headlines • Entertainment"
        case "general":
            return "Top Headlines • General"
        case "health":
            return "Top Headlines • Health"
        default:
            return "Top Headlines"
        }
    }
}

#Preview {
    NewsListView()
}
