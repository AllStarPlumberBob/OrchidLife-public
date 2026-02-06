# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

OrchidLife is a Flutter mobile app for orchid care management. It tracks orchids, schedules care tasks (watering, fertilizing, etc.), includes a lux meter for light measurement, and provides AI photo handoff to external services. Primary target is Android (namespace: `com.orchidlife.orchidlife`).

**Current status:** Early development. The active `lib/main.dart` is still the Flutter template. All implementation files are staged in the `Code Files/` directory and need to be integrated into `lib/` per the structure in `Code Files/SETUP_INSTRUCTIONS.md`.

## Build & Development Commands

```bash
# Install dependencies
flutter pub get

# Run the app (on connected device/emulator)
flutter run

# Generate Isar database code (required after model changes)
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
flutter build appbundle

# Clean rebuild
flutter clean && flutter pub get
```

## Architecture

### Target Directory Layout (once staged files are integrated)

```
lib/
  main.dart                    # Entry point - initializes Isar DB, creates demo data on first launch
  models/
    orchid.dart                # Isar collection - orchid profiles with variety, bloom status, color tags
    care_task.dart             # Isar collection - scheduled care with interval, due date tracking
    care_log.dart              # Isar collection - completion history (taken/skipped/missed/snoozed)
    light_reading.dart         # Isar collection - lux meter readings with level classification
  services/
    database_service.dart      # Singleton Isar DB access (4 collections: Orchid, CareTask, CareLog, LightReading)
  screens/
    main_navigation.dart       # Bottom nav container (Today, Orchids, Tools, Settings)
    today_screen.dart          # Home view - care tasks due today
    orchid_list_screen.dart    # Grid of all orchids
    orchid_detail_screen.dart  # Individual orchid with care schedule
    add_edit_orchid_screen.dart
    tools_screen.dart          # Lux meter + AI photo handoff
    settings_screen.dart       # Stats and preferences
  theme/
    app_theme.dart             # Material 3 theme - green palette (#2E7D32 primary)
  data/
    demo_data.dart             # First-launch sample Phalaenopsis with 4 care tasks
```

### Key Patterns

- **Database:** Isar (local NoSQL). Models use `@collection` annotation and require code generation (`build_runner`). Each model has a `part 'filename.g.dart';` directive.
- **State management:** StatefulWidget with `setState()` (no BLoC/Provider/Riverpod).
- **Database access:** `DatabaseService` singleton - call `DatabaseService.getInstance()` to initialize, then `DatabaseService.isar` for the Isar instance.
- **Navigation:** 4-tab `NavigationBar` using `IndexedStack` for tab persistence.
- **Models:** All have `copyWith()`, `validate()` where applicable, and enum extensions for display names.
- **First launch:** Uses `SharedPreferences` to detect first launch and create demo data.

### Key Enums

- `OrchidVariety` - 10 orchid types, each with `defaultWateringDays` and `lightNeeds`
- `BloomStatus` - blooming, budding, spiking, resting, dormant
- `CareType` - watering, fertilizing, misting, repotting, inspection, rotation, cleaning, custom
- `CareLogStatus` - completed, skipped, missed, snoozed
- `LightLevel` - veryLow, low, medium, bright, veryBright, direct

## Dependencies (planned, in Code Files/pubspec.yaml)

- **Database:** `isar`, `isar_flutter_libs`, `isar_generator` (dev), `build_runner` (dev)
- **Notifications:** `flutter_local_notifications`, `permission_handler`
- **Storage:** `shared_preferences`, `path_provider`
- **Images:** `image_picker`
- **Sensors:** `sensors_plus` (ambient light for lux meter)
- **Sharing/AI handoff:** `url_launcher`, `share_plus`
- **Linting:** `flutter_lints`

## Design Decisions

- **Offline-first:** All data stored locally in Isar, no external APIs.
- **AI handoff, not AI built-in:** The Tools screen launches external apps (Google Lens, ChatGPT, etc.) with pre-built contextual prompts rather than integrating AI directly.
- **Warm/encouraging tone:** UI language is friendly, not clinical. This is a consumer plant-care app.
- **Archiving over deletion:** Orchids have `isActive` flag for soft-delete.
