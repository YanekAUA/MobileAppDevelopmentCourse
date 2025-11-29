# Running the News App (Part 1)

Steps to run locally:

1. Copy `.env.example` to `.env` and set NEWS_API_KEY with your NewsAPI key.

2. Install dependencies:

```powershell
flutter pub get
```

3. Run the app in an emulator or device:

```powershell
flutter run
```

Notes:
- For part 1 we've implemented a clean architecture scaffold with a `Dio` network client and a `NewsBloc` for state management.
- The app will try to fetch top headlines from: `https://newsapi.org/v2/top-headlines?country=us`.
- If your API key is missing or wrong, the API will return a 401 error.

Files added:
- `lib/src/core/network/dio_client.dart` - Dio wrapper.
- `lib/src/core/config/env_config.dart` - Read NEWS_API_KEY from .env.
- `lib/src/core/injection/injection.dart` - DI using get_it.
- `lib/src/features/news/...` - implementation.

Next steps:
- Implement unit and bloc tests.
- Add detailed error states, caching, and list item navigation for Part 2.
