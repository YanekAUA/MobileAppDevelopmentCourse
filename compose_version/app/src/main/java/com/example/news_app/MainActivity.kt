package com.example.news_app

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.lifecycle.ViewModelProvider
import com.example.news_app.BuildConfig
import com.example.news_app.data.network.RetrofitClient
import com.example.news_app.data.network.NewsApiService
import com.example.news_app.data.repository.NewsRepositoryImpl
import com.example.news_app.domain.usecase.GetTopHeadlinesUseCase
import com.example.news_app.presentation.viewmodel.NewsViewModelFactory
import com.example.news_app.ui.screens.NewsListScreen
import com.example.news_app.ui.theme.NewsAppTheme

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
                Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
                    NewsListScreen(
                        newsViewModel = viewModel,
                    )
                }
            }
        }
    }
}

@Composable
fun Greeting(name: String, modifier: Modifier = Modifier) {
    Text(
        text = "Hello $name!",
        modifier = modifier
    )
}

@Preview(showBackground = true)
@Composable
fun GreetingPreview() {
    NewsAppTheme {
        Greeting("Android")
    }
}