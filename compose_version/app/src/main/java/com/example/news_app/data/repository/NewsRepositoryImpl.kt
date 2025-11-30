package com.example.news_app.data.repository

import com.example.news_app.data.network.NewsApiService
import com.example.news_app.domain.entities.Article
import com.example.news_app.domain.entities.ArticlesPage
import com.example.news_app.domain.repository.NewsRepository

class NewsRepositoryImpl(private val service: NewsApiService): NewsRepository {

    override suspend fun getTopHeadlines(
        country: String,
        category: String?,
        q: String?,
        page: Int,
        pageSize: Int,
    ): ArticlesPage {
        val resp = service.getTopHeadlines(country = country, category = category, q = q, page = page, pageSize = pageSize)
        val articles = resp.articles.map { dto ->
            val publishedAt = dto.publishedAt
            Article(
                sourceName = dto.source?.name,
                author = dto.author,
                title = dto.title,
                description = dto.description,
                url = dto.url,
                urlToImage = dto.urlToImage,
                publishedAt = publishedAt,
                content = dto.content,
            )
        }
        return ArticlesPage(articles = articles, totalResults = resp.totalResults)
    }
}
