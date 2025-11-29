package com.example.news_app.presentation.viewmodel

import com.example.news_app.domain.entities.Article

sealed class NewsState {
    object Initial : NewsState()
    object Loading : NewsState()
    data class Loaded(
        val articles: List<Article>,
        val hasReachedMax: Boolean = false,
        val isLoadingMore: Boolean = false,
    ) : NewsState()
    data class Error(val message: String) : NewsState()
}
