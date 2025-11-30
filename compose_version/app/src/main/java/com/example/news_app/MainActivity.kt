package com.example.news_app

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.fillMaxSize
import androidx.lifecycle.ViewModelProvider
import com.example.news_app.BuildConfig
import com.example.news_app.data.network.RetrofitClient
import com.example.news_app.data.network.NewsApiService
import com.example.news_app.data.repository.NewsRepositoryImpl
import com.example.news_app.domain.usecase.GetTopHeadlinesUseCase
import com.example.news_app.presentation.viewmodel.NewsViewModelFactory
import com.example.news_app.ui.screens.NewsDetailScreen
import com.example.news_app.ui.screens.NewsListScreen
import com.example.news_app.ui.theme.NewsAppTheme
import androidx.compose.material3.Scaffold
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.material3.Text

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        // Create network + repository + viewModel wiring
        val retrofit = RetrofitClient.create(apiKey = BuildConfig.NEWS_API_KEY)
        val apiService = retrofit.create(NewsApiService::class.java)
        val repository = NewsRepositoryImpl(apiService)
        val useCase = GetTopHeadlinesUseCase(repository)
        val factory = NewsViewModelFactory(useCase)
        val viewModel = ViewModelProvider(this, factory).get(com.example.news_app.presentation.viewmodel.NewsViewModel::class.java)

        setContent {
            NewsAppTheme {
                Scaffold(modifier = Modifier.fillMaxSize()) {
                    AppContent(viewModel = viewModel)
                }
            }
        }
    }
}

@Composable
fun AppContent(viewModel: com.example.news_app.presentation.viewmodel.NewsViewModel) {
    val selected = remember { mutableStateOf<Int?>(null) }
    val idx = selected.value
    if (idx == null) {
        NewsListScreen(newsViewModel = viewModel, onArticleClick = { index -> selected.value = index })
    } else {
        val article = viewModel.getArticleAt(idx)
        NewsDetailScreen(article = article, onBack = { selected.value = null })
    }
}

@Composable
fun Greeting(name: String, modifier: Modifier = Modifier) {
    Text(
        text = "Hello $name!",
        modifier = modifier
    )
}

@androidx.compose.ui.tooling.preview.Preview(showBackground = true)
@Composable
fun GreetingPreview() {
    NewsAppTheme {
        Greeting("Android")
    }
}