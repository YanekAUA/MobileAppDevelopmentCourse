# News App - SwiftUI Version

A native iOS news application built with SwiftUI following Clean Architecture principles.

## Quick Start

### Setup

1. Get API key from [newsapi.org](https://newsapi.org/)
2. Open `News/News.xcodeproj` in Xcode
3. Add to `Info.plist`:
   ```xml
   <key>NEWS_API_KEY</key>
   <string>YOUR_API_KEY</string>
   <key>NEWS_BASE_URL</key>
   <string>https://newsapi.org/v2</string>
   ```
4. Press `Cmd + R` to run

### Requirements

- iOS 15.0+
- Xcode 14.0+
- Swift 5.7+

## Features

- Fetch and display news articles
- Search with real-time results
- Infinite scroll pagination
- Pull-to-refresh
- Article details view
- Error handling & retry
- Loading states

## Architecture

Clean Architecture with 4 layers:
- **Core**: Infrastructure (Network, Config, DI, Logging)
- **Domain**: Business logic (Entities, Repositories, Usecases)
- **Data**: Data access (Models, Datasources, Repository implementations)
- **Presentation**: UI (ViewModels, Views)

## Project Structure

```
News/
├── Core/               # Infrastructure
│   ├── Config/
│   ├── Network/
│   ├── Injection/
│   └── Util/
├── Features/News/
│   ├── Domain/         # Business logic
│   ├── Data/           # Data access
│   └── Presentation/   # UI
└── NewsApp.swift
```
