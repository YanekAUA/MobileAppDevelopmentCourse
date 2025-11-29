package com.example.news_app.data.network

import retrofit2.http.GET
import retrofit2.http.Query

import com.example.news_app.data.models.ArticlesResponseDto

interface NewsApiService {
    @GET("top-headlines")
    suspend fun getTopHeadlines(
        @Query("country") country: String = "us",
        @Query("category") category: String? = null,
        @Query("q") q: String? = null,
        @Query("page") page: Int = 1,
        @Query("pageSize") pageSize: Int = 20,
    ): ArticlesResponseDto
}
