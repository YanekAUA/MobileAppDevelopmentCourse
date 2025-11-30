# SwiftUI News App

A clean architecture implementation of a news app using SwiftUI.

## Features

- Fetch top headlines from NewsAPI
- Search articles by keyword
- Filter by category
- Infinite scrolling pagination
- Pull to refresh
- Offline local search
- Article detail view

## Setup

1. Create `.env` file:
   ```
   NEWS_API_KEY=your_api_key_here
   NEWS_BASE_URL=https://newsapi.org/v2
   ```

2. Get API key from [NewsAPI.org](https://newsapi.org)

3. In Xcode:
   - Select target → Build Phases
   - Add `.env` to "Copy Bundle Resources"
   - Set iOS 16+ deployment target

4. Build and run:
   ```
   Cmd + B
   Cmd + R
   ```

## Architecture

- **Core** - Infrastructure (Config, Networking, Logging, DI)
- **Domain** - Business logic (Entities, Interfaces, Use cases)
- **Data** - Data access (Models, Data sources, Repositories)
- **Presentation** - UI (ViewModel, Views, Components)
