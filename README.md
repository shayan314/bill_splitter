# 💰 Bill Splitter App
### MAD University Project — Section B | Flutter

---

## ✅ Sir ki Requirements — Checklist

| Requirement | Status |
|---|---|
| 5-6 distinct screens | ✅ Splash, Home, Result, History, Settings |
| Provider state management | ✅ BillProvider with ChangeNotifier |
| Data Persistence (SQLite) | ✅ Bill history saved in local DB |
| Data Persistence (Shared Preferences) | ✅ Settings saved persistently |
| Custom Fonts (Google Fonts) | ✅ Poppins throughout |
| Input Validation | ✅ Form validation on bill amount |

---

## 📱 Screens

| Screen | Description |
|---|---|
| **Splash Screen** | Animated intro, initializes Provider + DB |
| **Home Screen** | Enter bill, select people & tip, calculate |
| **Result Screen** | Per-person amount, full breakdown, per-person list |
| **History Screen** | All saved bill splits from SQLite |
| **Settings Screen** | Currency, default tip & people (SharedPreferences) |

---

## 🚀 How to Run

### Requirements
- Flutter SDK 3.x: https://flutter.dev/docs/get-started/install
- Android Studio or VS Code
- Android emulator or physical device

### Steps

```bash
# 1. Go to project folder
cd bill_splitter

# 2. Install dependencies
flutter pub get

# 3. Run app
flutter run

# 4. Build APK for submission
flutter build apk --release
# APK will be at: build/app/outputs/flutter-apk/app-release.apk
```

---

## 📁 Project Structure

```
bill_splitter/
├── lib/
│   ├── main.dart                    # Entry point + Provider setup
│   ├── models/
│   │   └── bill_model.dart          # Bill data model
│   ├── providers/
│   │   └── bill_provider.dart       # State management (Provider)
│   ├── services/
│   │   ├── database_service.dart    # SQLite CRUD operations
│   │   └── preferences_service.dart # SharedPreferences
│   └── screens/
│       ├── splash_screen.dart       # Screen 1
│       ├── home_screen.dart         # Screen 2
│       ├── result_screen.dart       # Screen 3
│       ├── history_screen.dart      # Screen 4
│       └── settings_screen.dart    # Screen 5
├── pubspec.yaml
└── README.md
```

---

## 🛠️ Tech Stack

| Tech | Usage |
|---|---|
| Flutter 3.x | Framework |
| Dart | Language |
| **Provider** | State Management |
| **sqflite** | SQLite - Local Database |
| **shared_preferences** | Persistent Settings |
| **google_fonts** | Custom Fonts (Poppins) |

---

## 📊 Grading Criteria Coverage

| Criteria | Marks | How Covered |
|---|---|---|
| UI Design & Layout | 3 | Dark theme, Google Fonts, responsive layout, no overflow |
| Functionality & Logic | 3 | Correct bill/tip/per-person calculations, input validation |
| Database/API Integration | 2 | SQLite for history + SharedPreferences for settings |
| Code Structure | 2 | Provider pattern, separate models/services/screens |

---

*MAD Section B — Bill Splitter App*
