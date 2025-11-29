package com.example.news_app.ui.screens

// removed unused Image import
import android.widget.Toast
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Info
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.*
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.runtime.*
import androidx.compose.runtime.snapshotFlow
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import coil.compose.AsyncImage
import coil.request.ImageRequest
import com.example.news_app.BuildConfig
import com.example.news_app.domain.entities.Article
import com.example.news_app.presentation.viewmodel.NewsState
import com.example.news_app.presentation.viewmodel.NewsViewModel
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.*

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun NewsListScreen(
        newsViewModel: NewsViewModel = viewModel(),
) {
    val state by newsViewModel.state.collectAsState()
    var isSearching by remember { mutableStateOf(false) }
    var searchText by remember { mutableStateOf("") }
    val listState = rememberLazyListState()

    // Initial load
    LaunchedEffect(Unit) { newsViewModel.fetchTopHeadlines(null) }

    // Debounce search input
    LaunchedEffect(searchText) {
        if (searchText.isEmpty()) {
            // if empty, do not search; fetch top headlines
            newsViewModel.fetchTopHeadlines(null)
            return@LaunchedEffect
        }
        delay(500) // debounce
        newsViewModel.fetchTopHeadlines(searchText.trim())
    }

    // Load more when scrolling near the end
    LaunchedEffect(listState) {
        snapshotFlow {
            val layout = listState.layoutInfo
            val lastVisible = layout.visibleItemsInfo.lastOrNull()?.index ?: 0
            lastVisible to layout.totalItemsCount
        }
            .distinctUntilChanged()
            .collect { (lastVisible, total) ->
                // Only trigger when we have items and the user scrolled near the end
                if (total > 0 && lastVisible >= total - 5) {
                    // only attempt to load more when current state is Loaded and not already loading / reached max
                    val currentState = newsViewModel.state.value
                    if (currentState is NewsState.Loaded) {
                        if (!currentState.isLoadingMore && !currentState.hasReachedMax) {
                            newsViewModel.loadMoreHeadlines()
                        }
                    }
                }
            }
    }

    // If API key is empty, show message like Flutter version
    if (BuildConfig.NEWS_API_KEY.isEmpty()) {
        Scaffold(topBar = { TopAppBar(title = { Text("Top Headlines") }) }) { innerPadding ->
            Box(
                    modifier = Modifier.fillMaxSize().padding(innerPadding),
                    contentAlignment = Alignment.Center
            ) {
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Text("No News API Key", style = MaterialTheme.typography.titleLarge)
                    Spacer(modifier = Modifier.height(8.dp))
                    Text(
                            "Please add NEWS_API_KEY to your local gradle.properties and restart the app."
                    )
                }
            }
        }
        return
    }

    Scaffold(
            topBar = {
                TopAppBar(
                        title = {
                            if (isSearching) {
                                TextField(
                                        value = searchText,
                                        onValueChange = { searchText = it },
                                        modifier = Modifier.fillMaxWidth(),
                                        placeholder = { Text("Search headlines...") },
                                        singleLine = true,
                                        // Use default colors for simplicity
                                        )
                            } else {
                                Text("Top Headlines")
                            }
                        },
                        actions = {
                            IconButton(onClick = {
                                // When closing the search, clear the query and restore top headlines
                                if (isSearching) {
                                    searchText = ""
                                    isSearching = false
                                    newsViewModel.fetchTopHeadlines(null)
                                } else {
                                    isSearching = true
                                }
                            }) {
                                Icon(
                                        imageVector =
                                                if (isSearching) Icons.Default.Close
                                                else Icons.Default.Search,
                                        contentDescription = null
                                )
                            }
                        }
                )
            },
            floatingActionButton = {
                FloatingActionButton(
                        onClick = {
                            newsViewModel.fetchTopHeadlines(
                                    if (searchText.isBlank()) null else searchText
                            )
                        }
                ) { Icon(imageVector = Icons.Default.Refresh, contentDescription = "Refresh") }
            }
    ) { paddingValues ->
        Box(modifier = Modifier.padding(paddingValues)) {
            when (state) {
                is NewsState.Initial -> {
                    // show message
                    Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                        Text("Pull to load headlines")
                    }
                }
                is NewsState.Loading -> {
                    Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                        CircularProgressIndicator()
                    }
                }
                is NewsState.Loaded -> {
                    val loaded = state as NewsState.Loaded
                    if (loaded.articles.isEmpty()) {
                        Box(
                                modifier = Modifier.fillMaxSize(),
                                contentAlignment = Alignment.Center
                        ) {
                            Text(
                                    if (searchText.isBlank()) "No Results Found"
                                    else "No results for \"$searchText\""
                            )
                        }
                    } else {
                        LazyColumn(state = listState, modifier = Modifier.fillMaxSize()) {
                            itemsIndexed(loaded.articles) { index, article ->
                                ArticleItem(article = article)
                            }
                            // Loading more indicator
                            if (!loaded.hasReachedMax) {
                                item {
                                    Box(
                                            modifier = Modifier.fillMaxWidth().padding(16.dp),
                                            contentAlignment = Alignment.Center
                                    ) {
                                        if (loaded.isLoadingMore) CircularProgressIndicator()
                                        else Spacer(modifier = Modifier.height(8.dp))
                                    }
                                }
                            }
                        }
                    }
                }
                is NewsState.Error -> {
                    val errorMsg = (state as NewsState.Error).message
                    Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                        Column(horizontalAlignment = Alignment.CenterHorizontally) {
                            Text("Error: $errorMsg")
                            Spacer(modifier = Modifier.height(12.dp))
                            Button(
                                    onClick = {
                                        newsViewModel.fetchTopHeadlines(
                                                if (searchText.isBlank()) null else searchText
                                        )
                                    }
                            ) { Text("Retry") }
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun ArticleItem(article: Article) {
    val context = LocalContext.current
    Card(
            modifier = Modifier.padding(horizontal = 12.dp, vertical = 6.dp).fillMaxWidth(),
            shape = RoundedCornerShape(8.dp)
    ) {
        Row(
                modifier =
                        Modifier.padding(8.dp).clickable {
                            Toast.makeText(context, article.title ?: "", Toast.LENGTH_SHORT).show()
                        }
        ) {
            val imageUrl = article.urlToImage
            if (!imageUrl.isNullOrEmpty()) {
                AsyncImage(
                        model =
                                ImageRequest.Builder(LocalContext.current)
                                        .data(imageUrl)
                                        .crossfade(true)
                                        .build(),
                        contentDescription = article.title,
                        modifier = Modifier.size(72.dp)
                )
            } else {
                Box(modifier = Modifier.size(72.dp), contentAlignment = Alignment.Center) {
                    Icon(Icons.Default.Info, contentDescription = null)
                }
            }
            Spacer(modifier = Modifier.width(8.dp))
            Column(modifier = Modifier.weight(1f)) {
                Text(article.title ?: "No title", style = MaterialTheme.typography.titleMedium)
                if (!article.description.isNullOrEmpty()) {
                    Text(
                            article.description,
                            style = MaterialTheme.typography.bodyMedium,
                            maxLines = 3
                    )
                }
            }
        }
    }
}
