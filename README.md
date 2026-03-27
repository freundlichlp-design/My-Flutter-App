# MyFlutterApp

A Flutter demo application showcasing **Provider** for state management, **HTTP** for API calls, and **Named Routes** for navigation.

## Features

- Article list fetched from [JSONPlaceholder](https://jsonplaceholder.typicode.com/posts)
- Detail view for each article
- Loading, Error, and Success UI states
- Pull-to-refresh on the article list
- Null-safe Dart with `ChangeNotifier`-based state management

## Getting Started

```bash
flutter pub get
flutter run
```

## Project Structure

```
lib/
├── main.dart                  # App entry, Provider setup, routing
├── models/
│   └── article.dart           # Article data model
├── services/
│   └── article_service.dart   # HTTP client for JSONPlaceholder API
├── providers/
│   └── article_provider.dart  # ChangeNotifier for article state
└── screens/
    ├── home_page.dart          # Article list screen
    └── article_detail_page.dart # Article detail screen
```
