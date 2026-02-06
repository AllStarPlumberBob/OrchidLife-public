# 🌿 OrchidLife - Drift Database Setup

## What Changed
We switched from **Isar** (abandoned) to **Drift** (actively maintained SQLite wrapper).

## Quick Setup

### 1. Replace `pubspec.yaml`
Copy the new `pubspec.yaml` into your project root, replacing the old one.

### 2. Create folder structure
```
lib/
├── database/
│   └── database.dart      ← NEW: Single file for all database stuff
├── screens/
│   ├── main_navigation.dart
│   ├── today_screen.dart
│   ├── orchid_list_screen.dart
│   ├── orchid_detail_screen.dart
│   ├── add_edit_orchid_screen.dart
│   ├── tools_screen.dart
│   └── settings_screen.dart
├── theme/
│   └── app_theme.dart
└── main.dart
```

### 3. Copy all the files
Copy each `.dart` file to its corresponding location.

### 4. Generate database code
Drift uses code generation. Run this in your terminal:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

This creates `database.g.dart` automatically.

### 5. Run the app
```bash
flutter run
```

---

## Key Differences from Isar

| Aspect | Isar (old) | Drift (new) |
|--------|------------|-------------|
| Database type | NoSQL | SQLite |
| Models | Separate files with annotations | Tables defined in database.dart |
| Queries | Collection-based | SQL-like query builder |
| Code gen | `isar_generator` | `drift_dev` + `build_runner` |
| Maintenance | Abandoned (2023) | Actively maintained |

---

## Troubleshooting

### "Could not find database.g.dart"
Run the code generator:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### "Package not found"
Run:
```bash
flutter pub get
```

### Build errors after running generator
Make sure there are no syntax errors in `database.dart`. The generator will fail if the source file has issues.

---

## Files Included

1. **pubspec.yaml** - Dependencies with Drift instead of Isar
2. **lib/database/database.dart** - All tables and database operations
3. **lib/main.dart** - App entry point
4. **lib/theme/app_theme.dart** - Green/natural theme
5. **lib/screens/main_navigation.dart** - Bottom navigation
6. **lib/screens/today_screen.dart** - Tasks due today
7. **lib/screens/orchid_list_screen.dart** - List of orchids
8. **lib/screens/orchid_detail_screen.dart** - Orchid details & history
9. **lib/screens/add_edit_orchid_screen.dart** - Add/edit orchid form
10. **lib/screens/tools_screen.dart** - Lux meter & AI handoff
11. **lib/screens/settings_screen.dart** - App settings

---

## Next Steps (Phase 2)

Once this is running, the next phase will add:
- [ ] Notification service (flutter_local_notifications)
- [ ] Real lux sensor integration
- [ ] Photo management for orchids
- [ ] Data export/import

Good luck! 🌸
