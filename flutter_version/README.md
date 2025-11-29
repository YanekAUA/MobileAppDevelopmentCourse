## News App (Flutter)

This is the Flutter part of the News App homework. It shows top headlines using the NewsAPI.

Setup
1. Copy `.env.example` to `.env` and add your NewsAPI key: `NEWS_API_KEY=your_api_key_here`.
2. Install dependencies:

```powershell
flutter pub get
```

3. Run the app:

```powershell
flutter run
```

Notes
- This project follows a Clean Architecture pattern with Domain, Data, and Presentation layers.
- For Part 1 we implement Top Headlines list with refresh and basic list items.
- Further features (search, filtering, details) are planned for Part 2.

IMPORTANT: The app reads configuration from a `.env` file. We've added `.env` to the Flutter asset bundle (so it is available to the app at runtime) but `.env` remains listed in `.gitignore` to avoid committing secrets. Create a local `.env` file with your API key and do not commit it:

```
NEWS_API_KEY=your_api_key_here
NEWS_BASE_URL=https://newsapi.org/v2
```
