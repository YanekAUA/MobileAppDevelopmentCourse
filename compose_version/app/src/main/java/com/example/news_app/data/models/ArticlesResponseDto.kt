package com.example.news_app.data.models

import com.google.gson.annotations.SerializedName

data class ArticlesResponseDto(
    @SerializedName("status") val status: String?,
    @SerializedName("totalResults") val totalResults: Int = 0,
    @SerializedName("articles") val articles: List<ArticleDto> = emptyList(),
)

data class ArticleDto(
    @SerializedName("source") val source: SourceDto? = null,
    @SerializedName("author") val author: String? = null,
    @SerializedName("title") val title: String? = null,
    @SerializedName("description") val description: String? = null,
    @SerializedName("url") val url: String? = null,
    @SerializedName("urlToImage") val urlToImage: String? = null,
    @SerializedName("publishedAt") val publishedAt: String? = null,
)

data class SourceDto(
    @SerializedName("id") val id: String? = null,
    @SerializedName("name") val name: String? = null,
)
