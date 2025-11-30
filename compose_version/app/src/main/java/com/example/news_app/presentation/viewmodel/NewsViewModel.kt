package com.example.news_app.presentation.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.news_app.domain.usecase.GetTopHeadlinesUseCase
import com.example.news_app.domain.entities.Article
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

class NewsViewModel(private val getTopHeadlinesUseCase: GetTopHeadlinesUseCase) : ViewModel() {
    private val _state = MutableStateFlow<NewsState>(NewsState.Initial)
    val state: StateFlow<NewsState> = _state.asStateFlow()

    private var _currentPage = 1
    private val _pageSize = 20
    private var _hasReachedMax = false
    private var _isFetchingMore = false
    private var _totalResults = 0
    private var _currentQuery: String? = null
    private var _currentCategory: String? = null

    fun fetchTopHeadlines(q: String? = null, category: String? = null) {
        _currentQuery = q
        _currentCategory = category
        viewModelScope.launch {
            _state.value = NewsState.Loading
            _currentPage = 1
            _hasReachedMax = false
            try {
                val pageResult = getTopHeadlinesUseCase.execute(
                    country = "us",
                    category = _currentCategory,
                    q = _currentQuery,
                    page = _currentPage,
                    pageSize = _pageSize,
                )
                val articles = pageResult.articles
                _totalResults = pageResult.totalResults
                if (articles.size >= _totalResults) _hasReachedMax = true
                _state.value = NewsState.Loaded(articles, hasReachedMax = _hasReachedMax)
            } catch (e: Exception) {
                _state.value = NewsState.Error(e.toString())
            }
        }
    }

    fun loadMoreHeadlines() {
        if (_hasReachedMax || _isFetchingMore) return
        val current = _state.value
        if (current is NewsState.Loaded) {
            _isFetchingMore = true
            _state.value = NewsState.Loaded(current.articles, hasReachedMax = current.hasReachedMax, isLoadingMore = true)
            viewModelScope.launch {
                try {
                    val nextPage = _currentPage + 1
                    val pageResult = getTopHeadlinesUseCase.execute(
                        country = "us",
                        category = _currentCategory,
                        q = _currentQuery,
                        page = nextPage,
                        pageSize = _pageSize,
                    )
                    val newArticles = pageResult.articles
                    _totalResults = pageResult.totalResults
                    if (newArticles.isEmpty()) {
                        _hasReachedMax = true
                        _state.value = NewsState.Loaded(current.articles, hasReachedMax = true, isLoadingMore = false)
                    } else {
                        _currentPage = nextPage
                        val all = ArrayList<Article>(current.articles).apply { addAll(newArticles) }
                        if (all.size >= _totalResults) _hasReachedMax = true
                        _state.value = NewsState.Loaded(all, hasReachedMax = _hasReachedMax, isLoadingMore = false)
                    }
                } catch (e: Exception) {
                    _state.value = NewsState.Error(e.toString())
                }
                _isFetchingMore = false
            }
        }
    }

    // Helper to retrieve article by index when showing details
    fun getArticleAt(index: Int): Article? {
        val current = _state.value
        return if (current is NewsState.Loaded) {
            current.articles.getOrNull(index)
        } else null
    }
}
