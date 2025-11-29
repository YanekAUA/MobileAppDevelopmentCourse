package com.example.news_app.presentation.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.example.news_app.domain.usecase.GetTopHeadlinesUseCase

@Suppress("UNCHECKED_CAST")
class NewsViewModelFactory(private val useCase: GetTopHeadlinesUseCase) : ViewModelProvider.Factory {
    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        return when {
            modelClass.isAssignableFrom(NewsViewModel::class.java) -> NewsViewModel(useCase) as T
            else -> throw IllegalArgumentException("Unknown ViewModel class: " + modelClass.name)
        }
    }
}
