# Contributing to OrchidLife

Thanks for your interest in contributing! Here's how to get started.

## Development Setup

1. Install [Flutter](https://docs.flutter.dev/get-started/install) (SDK ≥ 3.5.0)
2. Clone the repo and install dependencies:
   ```bash
   git clone https://github.com/AllStarPlumberBob/OrchidLife-public.git
   cd OrchidLife-public
   flutter pub get
   ```
3. Run on a connected device or emulator:
   ```bash
   flutter run
   ```

## Building

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk

# Regenerate Drift database code (after schema changes)
flutter pub run build_runner build --delete-conflicting-outputs
```

## Code Style

- Follow the rules in `analysis_options.yaml` (based on `flutter_lints`)
- Run `flutter analyze` before submitting a PR — it should pass cleanly
- Auto-fix lint issues with `dart fix --apply`

## Architecture Overview

OrchidLife is offline-first with all data in a local SQLite database via Drift. See `CLAUDE.md` for detailed architecture notes, directory layout, and key patterns.

## Submitting Changes

1. Fork the repo and create a feature branch
2. Make your changes
3. Run `flutter analyze` and `flutter test`
4. Open a pull request with a clear description of what changed and why

## Reporting Issues

Use the [issue templates](https://github.com/AllStarPlumberBob/OrchidLife-public/issues/new/choose) for bug reports and feature requests.
