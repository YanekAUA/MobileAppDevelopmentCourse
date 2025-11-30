package com.example.news_app.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.unit.dp
import coil.compose.AsyncImage
import com.example.news_app.domain.entities.Article
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.ui.Alignment
import androidx.compose.ui.text.style.TextOverflow
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlinx.coroutines.launch
import org.jsoup.Jsoup
import androidx.compose.runtime.rememberCoroutineScope

// Removed cleaning helper per user preference: show raw content and fetch full article when requested

suspend fun fetchArticleTextFromUrl(url: String): String? {
    return try {
        val doc = withContext(Dispatchers.IO) { Jsoup.connect(url).userAgent("Mozilla/5.0").get() }
        // Try common article selectors
        val selectors = listOf("article", ".article", ".article-body", ".post-content", ".entry-content", ".content")
        for (sel in selectors) {
            val el = doc.selectFirst(sel)
            if (el != null) {
                val text = el.text().trim()
                if (text.isNotEmpty()) return text
            }
        }
        // fallback: collect <p> text
        val paragraphs = doc.select("p").map { it.text().trim() }.filter { it.isNotEmpty() }
        if (paragraphs.isNotEmpty()) paragraphs.joinToString("\n\n") else null
    } catch (_: Exception) {
        null
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Suppress("DEPRECATION")
@Composable
fun NewsDetailScreen(article: Article?, onBack: () -> Unit) {
    Scaffold(
        topBar = {
            TopAppBar(
                title = { /* Title moved into content */ },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(imageVector = Icons.Filled.ArrowBack, contentDescription = "Back")
                    }
                }
            )
        }
    ) { padding ->
        if (article == null) {
            Box(modifier = Modifier.padding(padding).fillMaxSize(), contentAlignment = Alignment.Center) {
                Text("Article not found")
            }
            return@Scaffold
        }

        // Use raw content/description as initial bodyText (no cleaning)
        val raw = article.content ?: article.description
        var bodyText by remember { mutableStateOf(raw ?: "") }
        var isLoadingFull by remember { mutableStateOf(false) }
        var fetchError by remember { mutableStateOf<String?>(null) }
        val coroutineScope = rememberCoroutineScope()

        Column(modifier = Modifier
            .padding(padding)
            .verticalScroll(rememberScrollState())) {
            val imageUrl = article.urlToImage
            if (!imageUrl.isNullOrEmpty()) {
                AsyncImage(
                    model = imageUrl,
                    contentDescription = article.title,
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(220.dp),
                    contentScale = ContentScale.Crop
                )
            }

            Column(modifier = Modifier.padding(16.dp)) {
                // Title moved here
                Text(article.title ?: "No title", style = MaterialTheme.typography.titleLarge)
                Spacer(modifier = Modifier.height(8.dp))
                Text(article.publishedAt ?: "", style = MaterialTheme.typography.bodySmall)
                Spacer(modifier = Modifier.height(12.dp))

                // Load full article button
                if (!article.url.isNullOrBlank()) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Button(onClick = {
                            if (!isLoadingFull) {
                                isLoadingFull = true
                                fetchError = null
                                coroutineScope.launch {
                                    val fetched = fetchArticleTextFromUrl(article.url)
                                    if (fetched != null) {
                                        bodyText = fetched
                                    } else {
                                        fetchError = "Failed to load full article"
                                    }
                                    isLoadingFull = false
                                }
                            }
                        }) {
                            if (isLoadingFull) CircularProgressIndicator(modifier = Modifier.size(18.dp))
                            else Text("Load full article")
                        }
                        Spacer(modifier = Modifier.width(12.dp))
                        if (fetchError != null) {
                            Text(fetchError!!, color = MaterialTheme.colorScheme.error)
                        }
                    }
                    Spacer(modifier = Modifier.height(12.dp))
                }

                // Show raw content or fetched full content; allow wrapping and no ellipsizing/truncation
                Text(
                    text = if (bodyText.isNotBlank()) bodyText else "No content available.",
                    style = MaterialTheme.typography.bodyMedium,
                    modifier = Modifier.fillMaxWidth(),
                    overflow = TextOverflow.Visible
                )

                Spacer(modifier = Modifier.height(12.dp))
                Text(article.author ?: "", style = MaterialTheme.typography.bodySmall)
                Spacer(modifier = Modifier.height(24.dp))
                Text(article.url ?: "", style = MaterialTheme.typography.bodySmall)
            }
        }
    }
}
