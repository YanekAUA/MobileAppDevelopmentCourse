# Compose Version - News App

This folder contains the Jetpack Compose version of the News feature that mirrors the Flutter implementation.

## What was implemented
- Retrofit + OkHttp client to call NewsAPI and attach the `apiKey` query parameter.
- DTOs for the API response: `ArticleDto`, `SourceDto`, and `ArticlesResponseDto`.
- Domain entities: `Article`, `ArticlesPage`.
- `NewsRepository` interface and `NewsRepositoryImpl` mapping DTOs to domain entities.
- `GetTopHeadlinesUseCase` to abstract repository calls.
- `NewsViewModel` with state flow and pagination logic mimicking Flutter's bloc logic.
- Compose UI: `NewsListScreen`, `ArticleItem` that mirrors the Flutter UI with search, pagination, FAB refresh and a small placeholder behavior.

## Running the app
1. Add your NewsAPI key to the project. Create a property named `NEWS_API_KEY` in `local.properties` at the root of this module, or in `gradle.properties`:

```
NEWS_API_KEY=YOUR_API_KEY
```

2. Build and run the app from Android Studio or via the command line:

```powershell
cd "d:\Yan\AUA\Mobile App Development\Homeworks\final-hw-part-1\compose_version"
./gradlew :app:assembleDebug
```
or open the project in Android Studio and run the Compose app.

## Notes & Differences from the Flutter version
- Used Retrofit + OkHttp for network instead of Dio.
- Manual Web/API key injection via a BuildConfig field (read from gradle properties) rather than a `.env` file.
- UI interactions are implemented with Jetpack Compose (LazyColumn, TopAppBar, FAB). The search is debounced using `delay`.
- Pull-to-refresh is implemented as a FAB refresh action (for minimal dependencies). You can add swipe-to-refresh using Accompanist or the newer Material3 pullRefresh APIs if needed.

## Potential Improvements
- Add Hilt for DI and better production-level setup.
- Add swipe-to-refresh and details screen to open the article link.
- Add unit/integration tests for repository and ViewModel logic.

If you want, I can now add unit tests or convert the DI wiring to Hilt.
