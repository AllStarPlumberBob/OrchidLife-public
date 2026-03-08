# OrchidLife

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

Smart orchid care management for Android. Track your orchids, schedule care reminders, measure light levels, and get AI-powered plant identification — all offline-first with no accounts or tracking.

## Features

- **Care scheduling** — Set reminders for watering, fertilizing, repotting, misting, inspecting, and pruning with customizable intervals
- **Today view** — See all care tasks due today, grouped by orchid
- **Lux meter** — Measure ambient light levels to find the perfect spot for your orchids
- **AI photo handoff** — Launch Google Lens, ChatGPT, or other apps with contextual prompts for plant identification
- **Care history** — Track completed and skipped tasks over time
- **Data export/import** — Full backup and restore of your collection
- **Dark mode** — Follows system theme
- **Fully offline** — All data stored locally, no accounts, no tracking

## Screenshots

<!-- TODO: Add screenshots -->

## Building from source

Requires [Flutter](https://docs.flutter.dev/get-started/install) 3.5+.

```bash
# Install dependencies
flutter pub get

# Generate Drift database code
flutter pub run build_runner build --delete-conflicting-outputs

# Run on connected device
flutter run

# Build release APK
flutter build apk

# Run tests
flutter test

# Static analysis
flutter analyze
```

## License

This project is licensed under the [GNU General Public License v3.0](LICENSE).
