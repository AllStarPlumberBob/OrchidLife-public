# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

OrchidLife is a Flutter mobile app for orchid care management. It tracks orchids, schedules care tasks (watering, fertilizing, etc.), includes a lux meter for light measurement, and provides AI photo handoff to external services. Primary target is Android (namespace: `com.orchidlife.orchidlife`).

**Current status:** Core features implemented. Database layer (Drift), screens, services, and theme are all in `lib/`.

## Build & Development Commands

```bash
# Install dependencies
flutter pub get

# Run the app (on connected device/emulator)
flutter run

# Generate Drift database code (required after table/schema changes)
flutter pub run build_runner build
flutter pub run build_runner build --delete-conflicting-outputs  # if conflicts

# Run all tests
flutter test

# Run a single test file
flutter test test/widget_test.dart

# Static analysis
flutter analyze

# Auto-fix lint issues
dart fix --apply

# Build Android APK / App Bundle
flutter build apk
flutter build apk --debug
flutter build appbundle

# Clean rebuild
flutter clean && flutter pub get
```

## Architecture

### Directory Layout

```
lib/
  main.dart                    # Entry point - initializes Drift DB, demo data (first run), notifications
  database/
    database.dart              # Drift database - table definitions, queries, demo data
    database.g.dart            # Generated Drift code (do not edit)
  services/
    notification_service.dart  # flutter_local_notifications scheduling, timezone init
    light_sensor_service.dart  # Ambient light sensor for lux meter
  screens/
    main_navigation.dart       # Bottom nav container (Today, Orchids, Tools, Settings)
    today_screen.dart          # Home view - care tasks due today, grouped by orchid
    orchid_list_screen.dart    # List of all orchids with due-task counts
    orchid_detail_screen.dart  # Individual orchid with care schedule + history
    add_edit_orchid_screen.dart # Add/edit orchid form
    tools_screen.dart          # Lux meter + AI photo handoff
    settings_screen.dart       # Notifications, default intervals, data management
  theme/
    app_theme.dart             # Material 3 theme - green palette (#2E7D32 primary), care type helpers
```

### Key Patterns

- **Database:** Drift (SQLite). Tables defined as classes in `database.dart`, generated code in `database.g.dart` via `build_runner`. Single `AppDatabase` class holds all queries.
- **State management:** Provider for dependency injection (`AppDatabase`, `NotificationService`, `LightSensorService`). Screens use `StreamBuilder` with Drift `watch()` methods for reactive UI.
- **Navigation:** 4-tab `NavigationBar` using `IndexedStack` for tab persistence.
- **First launch:** `SharedPreferences` flag (`demo_data_inserted`) skips demo data after first run.
- **Notifications:** `flutter_local_notifications` with timezone-aware scheduling. Permissions requested on enable.

### Key Enums (in database.dart)

- `CareType` - water, fertilize, repot, mist, inspect, prune, other

### Database Tables

- `Orchids` - orchid profiles (name, variety, location, photo, notes, dateAcquired, isDemo)
- `CareTasks` - scheduled care (orchidId, careType, intervalDays, nextDue, enabled, notifyHour/Minute)
- `CareLogs` - completion history (orchidId, careTaskId, careType, completedAt, notes, skipped)
- `LightReadings` - lux meter readings (orchidId, locationName, luxValue, readingAt)
- `Settings` - key-value settings store

## Dependencies

- **Database:** `drift`, `sqlite3_flutter_libs`, `drift_dev` (dev), `build_runner` (dev)
- **State:** `provider`
- **Notifications:** `flutter_local_notifications`, `timezone`, `permission_handler`
- **Storage:** `shared_preferences`, `path_provider`, `path`
- **Images:** `image_picker`
- **Sensors:** `sensors_plus` (ambient light for lux meter)
- **Sharing/AI handoff:** `url_launcher`, `share_plus`
- **Formatting:** `intl`
- **Linting:** `flutter_lints`

## Design Decisions

- **Offline-first:** All data stored locally in SQLite via Drift, no external APIs.
- **AI handoff, not AI built-in:** The Tools screen launches external apps (Google Lens, ChatGPT, etc.) with pre-built contextual prompts rather than integrating AI directly.
- **Warm/encouraging tone:** UI language is friendly, not clinical. This is a consumer plant-care app.
- **Core library desugaring:** Required for `flutter_local_notifications` on Android. Enabled in `android/app/build.gradle.kts`.
