# 🌿 OrchidLife - Scaffold Setup Instructions

## What You've Got

I've created all the starter files for OrchidLife. Here's what's included:

```
orchidlife_scaffold/
├── pubspec.yaml              # Dependencies
├── lib/
│   ├── main.dart             # App entry point
│   ├── models/
│   │   ├── orchid.dart       # Orchid data model
│   │   ├── care_task.dart    # Care task model
│   │   ├── care_log.dart     # Care log model
│   │   └── light_reading.dart # Lux meter readings
│   ├── services/
│   │   └── database_service.dart # Isar database
│   ├── screens/
│   │   ├── main_navigation.dart  # Bottom nav
│   │   ├── today_screen.dart     # Home screen
│   │   ├── orchid_list_screen.dart
│   │   ├── orchid_detail_screen.dart
│   │   ├── add_edit_orchid_screen.dart
│   │   ├── tools_screen.dart     # Lux meter, AI help
│   │   └── settings_screen.dart
│   ├── theme/
│   │   └── app_theme.dart    # Green/natural colors
│   └── data/
│       └── demo_data.dart    # Sample orchid
```

---

## Step-by-Step Setup

### Step 1: Replace pubspec.yaml

1. Open your `orchidlife/pubspec.yaml` file
2. **Replace ALL contents** with the contents of `pubspec.yaml` from the scaffold
3. Save the file

### Step 2: Get Dependencies

Open terminal in your project folder and run:

```bash
cd orchidlife
flutter pub get
```

You should see it download all the packages.

### Step 3: Create Folder Structure

In your `lib/` folder, create these folders:
- `lib/models/`
- `lib/services/`
- `lib/screens/`
- `lib/theme/`
- `lib/data/`

**In Android Studio:**
- Right-click on `lib` folder
- New → Directory
- Type the folder name

### Step 4: Copy All Files

Copy each file from the scaffold to your project:

| Scaffold File | Copy To |
|--------------|---------|
| `lib/main.dart` | `orchidlife/lib/main.dart` (replace existing) |
| `lib/models/orchid.dart` | `orchidlife/lib/models/orchid.dart` |
| `lib/models/care_task.dart` | `orchidlife/lib/models/care_task.dart` |
| `lib/models/care_log.dart` | `orchidlife/lib/models/care_log.dart` |
| `lib/models/light_reading.dart` | `orchidlife/lib/models/light_reading.dart` |
| `lib/services/database_service.dart` | `orchidlife/lib/services/database_service.dart` |
| `lib/screens/main_navigation.dart` | `orchidlife/lib/screens/main_navigation.dart` |
| `lib/screens/today_screen.dart` | `orchidlife/lib/screens/today_screen.dart` |
| `lib/screens/orchid_list_screen.dart` | `orchidlife/lib/screens/orchid_list_screen.dart` |
| `lib/screens/orchid_detail_screen.dart` | `orchidlife/lib/screens/orchid_detail_screen.dart` |
| `lib/screens/add_edit_orchid_screen.dart` | `orchidlife/lib/screens/add_edit_orchid_screen.dart` |
| `lib/screens/tools_screen.dart` | `orchidlife/lib/screens/tools_screen.dart` |
| `lib/screens/settings_screen.dart` | `orchidlife/lib/screens/settings_screen.dart` |
| `lib/theme/app_theme.dart` | `orchidlife/lib/theme/app_theme.dart` |
| `lib/data/demo_data.dart` | `orchidlife/lib/data/demo_data.dart` |

### Step 5: Generate Database Code

The models use Isar database which needs code generation. Run:

```bash
flutter pub run build_runner build
```

This creates the `.g.dart` files that Isar needs.

**If you see errors**, try:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Step 6: Run the App!

```bash
flutter run
```

Or click the green ▶️ Run button in Android Studio.

---

## What You Should See

When the app runs:

1. **Loading screen** with OrchidLife logo (briefly)
2. **Today screen** showing the demo orchid's care tasks
3. **Bottom navigation** with 4 tabs: Today, Orchids, Tools, Settings
4. **Demo orchid** called "My First Orchid" with watering, fertilizing, and inspection tasks

### Try These Things:

- ✅ Tap "Done" on a care task
- ✅ Go to "Orchids" tab and see the demo orchid
- ✅ Tap the orchid to see its detail page
- ✅ Add a new orchid with the + button
- ✅ Check out the "Tools" tab for reference guides
- ✅ Look at "Settings" to see the stats

---

## Troubleshooting

### "Cannot find module" errors
→ Run `flutter pub get` again

### "Target of URI doesn't exist" on .g.dart files
→ Run `flutter pub run build_runner build`

### App crashes on launch
→ Check the Run console for error messages
→ Make sure all files are in the right places
→ Try `flutter clean` then `flutter pub get` then `flutter run`

### Isar errors
→ Make sure you ran the build_runner command
→ Check that all model files have `part 'filename.g.dart';` line

---

## What's Working Now (Phase 1)

✅ Add/edit/delete orchids
✅ View orchid details
✅ Care task scheduling
✅ Mark tasks as done
✅ Today view with due tasks
✅ Demo orchid for new users
✅ Green/natural theme
✅ Quick reference guides

## Coming Next (Phase 2-3)

⏳ Notifications/alarms
⏳ Lux meter (light sensor)
⏳ AI photo help (handoff to ChatGPT/Google Lens)
⏳ Care history tracking
⏳ Skip/snooze tasks

---

## Need Help?

If something's not working, tell me:
1. What you were trying to do
2. What error message you see (copy the text from the Run console)
3. Which step you're on

I'll help you fix it! 🌿
