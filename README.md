# 📰 Flutter Articles App

A Flutter app that fetches and displays articles from JSONPlaceholder API with search, favorites, and theme switching.

## ✨ Features
- **Article List**: Fetch and display posts with cards
- **Search**: Filter by title or content
- **Details View**: Full article content display
- **Favorites**: Save favorite articles locally
- **Dark/Light Theme**: Toggle with persistent preference
- **Error Handling**: Network error detection with retry
- **Pull-to-Refresh**: Swipe down to reload

## 🛠️ Tech Stack
- **Flutter**: 3.19.5+
- **State Management**: Provider
- **HTTP**: http package
- **Storage**: shared_preferences
- **UI**: Material Design with custom themes

## 🚀 Setup

1. **Clone the repo**:
```bash
git clone https://github.com/Samarth-Pandey/Article-.git
cd Article-
```

2. **Install dependencies**:
```bash
flutter pub get
```

3. **Run the app**:
```bash
flutter run
```

## 🏗️ Architecture

```
lib/
├── models/        # Data models
├── providers/     # State management
├── services/      # API & storage
├── screens/       # UI pages
└── main.dart      # App entry point
```

## 🔄 State Flow

**ArticleProvider** manages:
- API data fetching
- Search filtering
- Favorite toggling
- Error states

**ThemeProvider** handles:
- Theme preference
- Dark/light switching

## ⚠️ Limitations
- No offline cache
- Basic error messages
- No pagination
- Case-sensitive search

## 📅 Roadmap
- Offline support
- Pagination
- Enhanced errors
- Social sharing
