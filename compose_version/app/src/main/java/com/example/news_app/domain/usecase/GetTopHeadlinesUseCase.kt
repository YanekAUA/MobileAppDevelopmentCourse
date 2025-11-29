package com.example.news_app.domain.usecase

import com.example.news_app.domain.entities.ArticlesPage
import com.example.news_app.domain.repository.NewsRepository

class GetTopHeadlinesUseCase(private val repository: NewsRepository) {
    suspend fun execute(
        country: String = "us",
        category: String? = null,
        q: String? = null,
        page: Int = 1,
        pageSize: Int = 20,
    ): ArticlesPage {
        return repository.getTopHeadlines(
            country = country,
            category = category,
            q = q,
            page = page,
            pageSize = pageSize,
        )
    }
}
