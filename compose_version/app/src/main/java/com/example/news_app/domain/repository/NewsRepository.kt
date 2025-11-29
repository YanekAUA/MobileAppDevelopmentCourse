package com.example.news_app.domain.repository

import com.example.news_app.domain.entities.ArticlesPage

interface NewsRepository {
    suspend fun getTopHeadlines(
        country: String = "us",
        category: String? = null,
        q: String? = null,
        page: Int = 1,
        pageSize: Int = 20,
    ): ArticlesPage
}
