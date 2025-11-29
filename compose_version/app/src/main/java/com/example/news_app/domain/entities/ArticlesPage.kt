package com.example.news_app.domain.entities

data class ArticlesPage(
    val articles: List<Article>,
    val totalResults: Int,
)
