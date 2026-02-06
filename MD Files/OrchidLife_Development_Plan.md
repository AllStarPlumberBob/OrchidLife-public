# 🌿 OrchidLife - Development Plan

## Document Info
- **Version:** 1.1 (Finalized)
- **Created:** January 31, 2026
- **App Name:** OrchidLife
- **Based on:** MDAlarm codebase (Flutter/Dart)
- **Target Platform:** Android 14+ (iOS later)

---

## ✅ Key Decisions Made

| Decision | Choice |
|----------|--------|
| **App Name** | OrchidLife |
| **Phase 1 Scope** | All care types from day one |
| **Special Features** | Lux meter + Voice assistant integration |
| **Notifications** | User configurable (gentle/persistent) |
| **Demo Data** | Include sample orchid |
| **Theme** | Green/natural color scheme |

---

## 1. App Vision & Purpose

### The Problem
Orchid care is notoriously tricky. Most orchids die from:
- **Overwatering** (the #1 killer)
- **Inconsistent care** (forgetting to water for weeks, then overcompensating)
- **Wrong timing** (watering on a calendar schedule vs. when the plant needs it)
- **Not knowing what each orchid variety needs**

### The Solution
OrchidCare is a smart reminder app that:
- Tracks each orchid individually (because a Phalaenopsis needs different care than a Dendrobium)
- Sends timely reminders based on each plant's schedule
- Logs care history so you can see patterns
- Adapts reminders based on seasons and conditions

### Target Users
1. **Orchid beginners** - Need guidance and consistent reminders
2. **Collectors with multiple orchids** - Need to track many plants with different schedules
3. **Busy plant parents** - Need reliable notifications they won't miss

---

## 2. Core Features (MVP - Minimum Viable Product)

### Phase 1: Foundation (Weeks 1-2)
These are the "must have" features to make the app usable.

| Feature | Description | Reuse from MDAlarm |
|---------|-------------|-------------------|
| **Orchid Profiles** | Add orchids with name, photo, variety, purchase date | Patient model, photo picker |
| **All Care Types** | Watering, fertilizing, misting, repotting, inspection, rotation, cleaning | Medication scheduling |
| **Smart Reminders** | Reliable notifications that work when app is closed | Full notification system |
| **Care Logging** | Record when you complete/skip care tasks | DoseLog system |
| **Today View** | See what needs care today | TodayScreen |
| **🆕 Lux Meter** | Measure light levels using phone sensor/camera | New feature |
| **🆕 AI Help Handoff** | Send photos to Google Lens/ChatGPT/Gemini/Siri for diagnosis | New feature |
| **Demo Orchid** | Sample orchid to show how app works | New feature |

### Phase 2: Enhanced Experience (Weeks 3-4)
| Feature | Description | Reuse from MDAlarm |
|---------|-------------|-------------------|
| **Orchid Library** | Browse/manage all your orchids | PatientsScreen grid |
| **Care History** | View past care for each orchid | (New, but uses DoseLog) |
| **Snooze/Skip** | Delay a reminder or mark as skipped | Notification actions |
| **Permission Wizard** | Guide users through Android permissions | Full permission system |

### Phase 3: Smart Features (Weeks 5-6)
| Feature | Description | Reuse from MDAlarm |
|---------|-------------|-------------------|
| **Variety Presets** | Auto-fill care schedules for common orchid types | (New feature) |
| **Seasonal Adjustments** | Remind to change watering frequency in winter | (New feature) |
| **Health Tracking** | Log bloom status, leaf condition, root health | (New feature) |
| **Photo Timeline** | Visual history of your orchid's growth | (New feature) |

### Future Ideas (Post-MVP)
- 🌡️ Weather integration (adjust watering based on humidity)
- 📊 Statistics dashboard (care consistency, bloom tracking)
- 🔔 Escalating reminders (more urgent if you keep missing)
- ☁️ Cloud backup
- 👥 Share orchid profiles
- 🤖 AI plant health diagnosis from photos

---

## 2.5 New Feature Specifications

### 🔆 Lux Meter Feature

**What it does:**
Uses the phone's ambient light sensor (or camera) to measure light intensity in lux. This helps users find the perfect spot for their orchids.

**How it works:**
```
┌────────────────────────────────────┐
│        🔆 Light Meter              │
├────────────────────────────────────┤
│                                    │
│         ┌─────────────┐            │
│         │             │            │
│         │    2,450    │            │
│         │     lux     │            │
│         │             │            │
│         └─────────────┘            │
│                                    │
│    ████████████░░░░░░░░            │
│    |-------|-------|------|        │
│   Low    Medium   Bright  Direct   │
│                                    │
│  💡 "Bright indirect light"        │
│  ✅ Perfect for Phalaenopsis!      │
│                                    │
│  [Save Reading]  [Compare Spots]   │
└────────────────────────────────────┘
```

**Light Level Guide:**
| Lux Range | Description | Good For |
|-----------|-------------|----------|
| 0-500 | Low light | Jewel orchids, Paphiopedilum |
| 500-1,500 | Medium | Phalaenopsis, Miltonia |
| 1,500-3,000 | Bright indirect | Most orchids |
| 3,000-5,000 | Very bright | Dendrobium, Cattleya, Oncidium |
| 5,000+ | Direct sun | Vanda (with care) |

**Technical Implementation:**
- Use `sensors_plus` package for ambient light sensor
- Fallback: Use camera exposure metering
- Store readings per orchid location
- Show historical readings (morning vs evening light)

**User Flow:**
1. User goes to orchid detail → taps "Check Light"
2. App reads light sensor for 3 seconds (averaging)
3. Shows reading with recommendation
4. Option to save reading for this orchid's location
5. Can compare different spots in the house

---

### 🤖 AI Help Handoff (Expanded)

**The Big Idea:**
OrchidLife doesn't try to be an AI plant expert. Instead, it acts as a **smart launcher** that hands off questions AND photos to the AI services users already have (Google Lens, ChatGPT, Gemini, Siri, Claude, etc.)

**Two Modes:**

#### Mode 1: Text-Based Help (Quick Questions)
User picks a problem category → App builds a search query → Opens Google/Voice Assistant

#### Mode 2: Photo-Based AI Diagnosis (🆕 THE BIG FEATURE)
User takes/selects a photo of the problem → App hands it to their preferred AI for analysis

**How Photo Handoff Works:**
```
┌────────────────────────────────────┐
│     📸 Get AI Help for Rosie       │
├────────────────────────────────────┤
│                                    │
│  Take or select a photo of the     │
│  problem (leaves, roots, spots)    │
│                                    │
│      ┌──────────────────┐          │
│      │                  │          │
│      │   [📷 Camera]    │          │
│      │                  │          │
│      │   [🖼️ Gallery]   │          │
│      │                  │          │
│      └──────────────────┘          │
│                                    │
├────────────────────────────────────┤
│  After photo is selected:          │
│                                    │
│  ┌──────────────────────────────┐  │
│  │      [Photo Preview]         │  │
│  └──────────────────────────────┘  │
│                                    │
│  "What's wrong with my             │
│   Phalaenopsis orchid?"            │
│  [Edit question...]                │
│                                    │
│  Send to:                          │
│  ┌────────┐ ┌────────┐ ┌────────┐  │
│  │Google  │ │ Chat   │ │ Gemini │  │
│  │ Lens   │ │  GPT   │ │        │  │
│  └────────┘ └────────┘ └────────┘  │
│  ┌────────┐ ┌────────┐ ┌────────┐  │
│  │ Claude │ │  Siri  │ │ Share  │  │
│  │        │ │        │ │  ...   │  │
│  └────────┘ └────────┘ └────────┘  │
│                                    │
└────────────────────────────────────┘
```

**Supported AI Services:**

| Service | Platform | How We Launch | Best For |
|---------|----------|---------------|----------|
| **Google Lens** | Android/iOS | Direct intent with image | Visual plant ID, disease spotting |
| **ChatGPT** | Android/iOS | Share sheet with image + text | Detailed diagnosis & advice |
| **Gemini** | Android/iOS | Share sheet or direct app | Google's latest AI |
| **Claude** | Android/iOS | Share sheet with image + text | Nuanced plant care advice |
| **Siri + Apple Intelligence** | iOS | Shortcuts with image | iOS users |
| **Google Image Search** | Web | Upload to lens.google.com | Reverse image search |
| **Any AI App** | Both | System share sheet | User's choice |

**Pre-Built Prompts:**
The app pre-fills a helpful prompt so users don't have to type:

```dart
String buildPhotoPrompt(OrchidVariety variety, String? specificIssue) {
  final base = "This is my ${variety.displayName} orchid. ";
  
  if (specificIssue != null) {
    return base + "I'm concerned about $specificIssue. "
      "What's wrong and how do I fix it?";
  }
  
  return base + "Can you identify any health issues and "
    "tell me how to care for it?";
}

// Examples:
// "This is my Phalaenopsis orchid. I'm concerned about yellow leaves. 
//  What's wrong and how do I fix it?"
//
// "This is my Dendrobium orchid. Can you identify any health issues 
//  and tell me how to care for it?"
```

**Technical Implementation:**

```dart
class AIHandoffService {
  
  // Take photo and get ready for handoff
  Future<File?> captureOrSelectPhoto() async {
    // Use image_picker to get photo
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.camera, // or gallery
      maxWidth: 1920,
      imageQuality: 85,
    );
    return image != null ? File(image.path) : null;
  }
  
  // Launch Google Lens with image
  Future<void> openGoogleLens(File image) async {
    // Android: Intent to Google Lens
    // iOS: Open in Google app with lens mode
    final intent = AndroidIntent(
      action: 'android.intent.action.SEND',
      type: 'image/*',
      package: 'com.google.android.googlequicksearchbox',
      arguments: {'EXTRA_STREAM': image.path},
    );
    await intent.launch();
  }
  
  // Share to any app (ChatGPT, Claude, Gemini, etc.)
  Future<void> shareToAI(File image, String prompt) async {
    await Share.shareXFiles(
      [XFile(image.path)],
      text: prompt,
      subject: 'Orchid Health Check',
    );
    // Opens system share sheet - user picks their AI app
  }
  
  // Open ChatGPT directly (if installed)
  Future<void> openChatGPT(File image, String prompt) async {
    // Deep link to ChatGPT with image
    // Falls back to share sheet if not installed
  }
  
  // Open Google Gemini
  Future<void> openGemini(File image, String prompt) async {
    // Launch Gemini app with image and prompt
  }
  
  // iOS: Trigger Siri with image context
  Future<void> invokeSiri(File image, String prompt) async {
    // Use Shortcuts integration
  }
}
```

**User Flow Example:**

1. User notices yellow spots on their Phalaenopsis
2. Opens OrchidLife → Goes to "Rosie" → Taps "🆘 Get Help"
3. Taps "📷 Take Photo" → Captures the yellow leaf
4. App shows preview with pre-filled prompt:
   *"This is my Phalaenopsis orchid. Can you identify any health issues?"*
5. User taps "ChatGPT" button
6. ChatGPT opens with the photo and prompt ready
7. User gets expert AI diagnosis!

**Why This Approach Wins:**

| Traditional Approach | Our Approach |
|---------------------|--------------|
| Build our own AI model | Use world-class existing AI |
| Train on plant diseases | Already trained on millions of plant images |
| Maintain accuracy | Always up-to-date (AI providers update) |
| High development cost | Near-zero AI development cost |
| Limited knowledge | Access to vast knowledge bases |
| App size bloat | Lightweight app |

**The Key Insight:**
We're not competing with Google/OpenAI/Anthropic. We're **partnering** with them by making it dead simple to get their help in context. The user gets the best of both worlds:
- OrchidLife for tracking & reminders (our expertise)
- AI services for diagnosis & advice (their expertise)

---

## 3. Technical Architecture

### Tech Stack (Same as MDAlarm)
```
┌─────────────────────────────────────────────────┐
│                   Flutter UI                     │
│         (Dart - Cross-platform framework)        │
├─────────────────────────────────────────────────┤
│                  State Layer                     │
│            (StatefulWidgets for now)             │
├─────────────────────────────────────────────────┤
│                Service Layer                     │
│    OrchidService, CareService, AlarmService      │
├─────────────────────────────────────────────────┤
│                 Database                         │
│              (Isar - local DB)                   │
├─────────────────────────────────────────────────┤
│              Native Android                      │
│    (Kotlin - Alarms, Notifications, Boot)        │
└─────────────────────────────────────────────────┘
```

### Why This Stack?
- **Flutter**: Write once, works on Android (and iOS later)
- **Isar**: Fast local database, no server needed, works offline
- **Kotlin**: Required for reliable Android alarms/notifications

### Project Structure
```
orchidlife/
├── android/
│   └── app/src/main/
│       ├── AndroidManifest.xml      # Permissions & receivers
│       └── kotlin/.../
│           ├── AlarmReceiver.kt     # Handles alarm triggers
│           ├── BootReceiver.kt      # Reschedules after reboot
│           └── NotificationActionReceiver.kt
├── lib/
│   ├── main.dart                    # App entry point
│   ├── models/
│   │   ├── orchid.dart              # Orchid data model
│   │   ├── care_task.dart           # Care schedule model
│   │   ├── care_log.dart            # Care history model
│   │   └── light_reading.dart       # 🆕 Lux meter readings
│   ├── services/
│   │   ├── database_service.dart    # Isar setup
│   │   ├── orchid_service.dart      # CRUD for orchids
│   │   ├── care_service.dart        # Care task management
│   │   ├── notification_service.dart # Push notifications
│   │   ├── alarm_service.dart       # Schedule alarms
│   │   ├── permission_service.dart  # Handle permissions
│   │   ├── light_sensor_service.dart # 🆕 Lux meter
│   │   └── ai_handoff_service.dart  # 🆕 Photo AI + Voice assistant
│   ├── screens/
│   │   ├── today_screen.dart        # Main "what needs care" view
│   │   ├── orchid_list_screen.dart  # All orchids grid
│   │   ├── orchid_detail_screen.dart
│   │   ├── add_edit_orchid_screen.dart
│   │   ├── care_history_screen.dart
│   │   ├── light_meter_screen.dart  # 🆕 Lux meter UI
│   │   ├── ai_help_screen.dart      # 🆕 Photo + text AI handoff
│   │   └── settings_screen.dart
│   ├── widgets/
│   │   ├── orchid_card.dart
│   │   ├── care_task_tile.dart
│   │   ├── care_action_buttons.dart
│   │   ├── light_level_indicator.dart # 🆕
│   │   └── empty_state.dart
│   ├── theme/
│   │   └── app_theme.dart           # Green/natural colors
│   ├── utils/
│   │   └── text_utils.dart
│   └── data/
│       ├── demo_data.dart           # 🆕 Sample orchid
│       └── variety_presets.dart     # 🆕 Care recommendations
└── pubspec.yaml                     # Dependencies
```

### Key Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Database
  isar: ^3.1.0+1
  isar_flutter_libs: ^3.1.0+1
  path_provider: ^2.1.1
  
  # Notifications & Alarms
  flutter_local_notifications: ^18.0.1
  permission_handler: ^11.3.1
  
  # Storage
  shared_preferences: ^2.2.2
  
  # Images
  image_picker: ^1.0.7
  
  # 🆕 Lux Meter
  sensors_plus: ^4.0.2        # Light sensor access
  camera: ^0.10.5+9           # Fallback light measurement
  
  # 🆕 AI Handoff (Photo + Voice)
  url_launcher: ^6.2.5        # Open Google search, web links
  android_intent_plus: ^4.0.3 # Launch Google Assistant/Lens
  share_plus: ^7.2.2          # Share photo+text to any AI app
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  isar_generator: ^3.1.0+1
  build_runner: ^2.4.8
```

---

## 4. Data Models

### Orchid (like Patient in MDAlarm)
```dart
class Orchid {
  int id;
  String name;              // "Kitchen Window Orchid"
  String? nickname;         // "Rosie"
  OrchidVariety variety;    // Phalaenopsis, Dendrobium, etc.
  String? photoPath;        // Local photo
  String colorTag;          // For visual organization
  String? location;         // "Living room windowsill"
  DateTime? purchaseDate;
  DateTime? lastBloomDate;
  BloomStatus bloomStatus;  // blooming, budding, resting, dormant
  String? notes;
  bool isActive;            // Archive without deleting
  DateTime createdAt;
}
```

### CareTask (like Medication in MDAlarm)
```dart
class CareTask {
  int id;
  int orchidId;             // Links to Orchid
  CareType careType;        // watering, fertilizing, misting, repotting
  int intervalDays;         // Every X days
  String? preferredTime;    // "09:00"
  String? instructions;     // "Use rain water, room temp"
  bool isActive;
  DateTime? lastCompleted;
  DateTime? nextDue;
  DateTime createdAt;
}

enum CareType {
  watering,     // 💧
  fertilizing,  // 🌱
  misting,      // 💨
  repotting,    // 🪴
  inspection,   // 🔍 Check roots/leaves
  rotation,     // 🔄 Turn for even light
  cleaning,     // 🧹 Wipe leaves
  custom        // User-defined
}
```

### CareLog (like DoseLog in MDAlarm)
```dart
class CareLog {
  int id;
  int orchidId;
  int careTaskId;
  DateTime scheduledDate;
  DateTime? completedAt;
  CareLogStatus status;     // completed, skipped, missed
  String? notes;            // "Roots looked dry"
  String? photoPath;        // Before/after photo
  DateTime createdAt;
}

enum CareLogStatus {
  completed,   // ✅ Done
  skipped,     // ⏭️ Intentionally skipped (went on vacation)
  missed,      // ❌ Forgot / didn't do it
  snoozed      // ⏰ Will do later today
}
```

### OrchidVariety (Preset data)
```dart
enum OrchidVariety {
  phalaenopsis,    // Most common, "moth orchid"
  dendrobium,
  cattleya,
  oncidium,
  vanda,
  paphiopedilum,   // "Slipper orchid"
  miltonia,
  cymbidium,
  zygopetalum,
  other
}

// Each variety has default care recommendations:
// - Phalaenopsis: Water every 7-10 days, fertilize monthly
// - Dendrobium: Water every 5-7 days, needs dry period
// etc.
```

### LightReading (🆕 For Lux Meter)
```dart
class LightReading {
  int id;
  int? orchidId;          // Optional - can take general readings
  String? locationName;   // "Kitchen window", "Bathroom shelf"
  int luxValue;           // Raw lux reading
  LightLevel level;       // Calculated category
  DateTime readingTime;   // When was this taken
  String? notes;
}

enum LightLevel {
  veryLow,    // 0-200 lux - Too dark for most orchids
  low,        // 200-500 lux - Low light orchids only
  medium,     // 500-1500 lux - Phalaenopsis sweet spot
  bright,     // 1500-3000 lux - Most orchids thrive
  veryBright, // 3000-5000 lux - High light orchids
  direct      // 5000+ lux - Direct sun, use caution
}
```

---

## 5. User Interface Design

### Design Principles
1. **Calming & Natural** - Soft greens, earthy tones (not clinical like MDAlarm)
2. **Visual First** - Big orchid photos, minimal text
3. **Quick Actions** - One tap to mark as watered
4. **Forgiving** - Easy to undo, snooze, or skip

### Color Palette - "Natural Green" Theme
```
// Primary Colors
Primary:        #2E7D32  (Forest Green - main actions)
PrimaryLight:   #4CAF50  (Fresh Green - highlights)
PrimaryDark:    #1B5E20  (Deep Green - headers)

// Secondary/Accent
Secondary:      #8D6E63  (Warm Brown - earthy accent)
Accent:         #FFB74D  (Soft Orange - notifications/alerts)

// Backgrounds
Background:     #F1F8E9  (Pale Green tint - main bg)
Surface:        #FFFFFF  (Pure White - cards)
SurfaceVariant: #E8F5E9  (Light Green - secondary cards)

// Text
TextPrimary:    #1B1B1B  (Near Black)
TextSecondary:  #5D7B5F  (Muted Green-Gray)
TextOnPrimary:  #FFFFFF  (White on green buttons)

// Status Colors (for care tasks)
NeedsCare:      #FF9800  (Orange - attention needed)
Overdue:        #E53935  (Red - missed care)
Completed:      #43A047  (Green - done)
Upcoming:       #42A5F5  (Blue - scheduled)
Skipped:        #9E9E9E  (Gray - intentionally skipped)

// Special
Bloom:          #E91E63  (Pink - flowering status)
LuxHigh:        #FFF176  (Yellow - bright light)
LuxLow:         #90A4AE  (Blue-gray - low light)
```

### Typography
- **Headlines:** Rounded, friendly (e.g., Nunito, Quicksand)
- **Body:** Clean, readable (e.g., Open Sans, Roboto)
- **Numbers:** Monospace for lux readings

### Key Screens

#### 1. Today Screen (Home)
```
┌────────────────────────────────────┐
│  🌿 Good Morning!                  │
│  3 orchids need care today         │
├────────────────────────────────────┤
│  ┌──────────────────────────────┐  │
│  │ 🪴 Kitchen Phal              │  │
│  │ 💧 Water today               │  │
│  │ [Done ✓]  [Skip]  [Snooze]   │  │
│  └──────────────────────────────┘  │
│                                    │
│  ┌──────────────────────────────┐  │
│  │ 🪴 Bedroom Dendrobium        │  │
│  │ 🌱 Fertilize today           │  │
│  │ [Done ✓]  [Skip]  [Snooze]   │  │
│  └──────────────────────────────┘  │
├────────────────────────────────────┤
│  📅 Upcoming This Week             │
│  • Thu: Water Office Orchid        │
│  • Sat: Mist all orchids           │
├────────────────────────────────────┤
│  🔆 Quick Tools                    │
│  [Light Meter]  [Get Help 🆘]      │
└────────────────────────────────────┘

[Today]  [Orchids]  [Calendar]  [More]
```

#### 2. Orchid Grid Screen
```
┌────────────────────────────────────┐
│  My Orchids (6)            [+ Add] │
├────────────────────────────────────┤
│  ┌─────────┐  ┌─────────┐         │
│  │  📷     │  │  📷     │         │
│  │ Kitchen │  │ Bedroom │         │
│  │  Phal   │  │ Dendro  │         │
│  │ 💧 2d   │  │ ✅ OK   │         │
│  └─────────┘  └─────────┘         │
│                                    │
│  ┌─────────┐  ┌─────────┐         │
│  │  📷     │  │  📷     │         │
│  │ Office  │  │  Mini   │         │
│  │ Cattleya│  │  Phal   │         │
│  │ 🌱 now! │  │ 💧 5d   │         │
│  └─────────┘  └─────────┘         │
└────────────────────────────────────┘
```

#### 3. Orchid Detail Screen
```
┌────────────────────────────────────┐
│  ←                          [Edit] │
│         ┌───────────┐              │
│         │           │              │
│         │   📷      │              │
│         │  (photo)  │              │
│         └───────────┘              │
│       Kitchen Phalaenopsis         │
│       "Rosie" • Blooming 🌸        │
├────────────────────────────────────┤
│  📍 Location: Kitchen window       │
│  🔆 Last light: 1,850 lux (Bright) │
│     [Check Light Now]              │
├────────────────────────────────────┤
│  Care Schedule                     │
│  ├─ 💧 Water every 7 days          │
│  │     Next: Tomorrow              │
│  ├─ 🌱 Fertilize every 30 days     │
│  │     Next: Feb 15                │
│  └─ 💨 Mist every 3 days           │
│        Next: Today                 │
├────────────────────────────────────┤
│  Recent Care                       │
│  • Jan 28 - Watered ✅             │
│  • Jan 25 - Misted ✅              │
│  • Jan 21 - Watered ✅             │
│                    [View All →]    │
├────────────────────────────────────┤
│  🆘 Having problems?               │
│  [Get Help with This Orchid]       │
├────────────────────────────────────┤
│  Notes                             │
│  "Bought from farmer's market.     │
│   Likes morning sun."              │
└────────────────────────────────────┘
```

---

## 6. Notification Strategy

### Notification Types
1. **Care Reminder** - "Time to water Kitchen Phal! 💧"
2. **Missed Care Alert** - "You haven't watered Rosie in 10 days"
3. **Weekly Summary** - "This week: 12 tasks completed, 2 skipped"

### Notification Actions (Quick buttons)
- ✅ **Done** - Mark as completed
- ⏰ **Snooze 1hr** - Remind again later
- ⏭️ **Skip** - Won't do today

### Timing Strategy
- Default reminder time: 9:00 AM (configurable)
- Escalating reminders if ignored (optional):
  - First: 9:00 AM
  - If not done: 2:00 PM
  - Final: 6:00 PM

---

## 7. Development Phases & Timeline

### Phase 1: Foundation (Week 1-2)
**Goal:** Basic app that can track orchids and send reminders

- [ ] Project setup (Flutter, dependencies)
- [ ] Database models (Orchid, CareTask, CareLog, LightReading)
- [ ] Database service (Isar setup)
- [ ] Add/Edit Orchid screen
- [ ] Orchid list screen
- [ ] Basic notification service
- [ ] Permission handling (copy from MDAlarm)
- [ ] Demo orchid data

**Deliverable:** Can add orchids and receive test notifications

### Phase 2: Core Features (Week 3-4)
**Goal:** Fully functional care tracking

- [ ] All care task types (water, fertilize, mist, repot, etc.)
- [ ] Care task scheduling (interval-based)
- [ ] Today screen with due tasks
- [ ] Quick actions (Done/Skip/Snooze)
- [ ] Care logging
- [ ] Orchid detail screen
- [ ] Alarm scheduling (Android native)
- [ ] Boot receiver (survive restarts)
- [ ] Notification settings (gentle/persistent toggle)

**Deliverable:** Complete daily care workflow

### Phase 3: Special Features (Week 5-6)
**Goal:** Lux meter and AI help handoff

- [ ] 🔆 Light sensor service
- [ ] 🔆 Lux meter screen UI
- [ ] 🔆 Light level recommendations per variety
- [ ] 🔆 Save readings per orchid/location
- [ ] 🤖 AI handoff service
- [ ] 🤖 Photo capture/selection for diagnosis
- [ ] 🤖 Pre-built prompts with orchid context
- [ ] 🤖 Google Lens direct launch
- [ ] 🤖 Share sheet integration (ChatGPT, Claude, Gemini, etc.)
- [ ] 🤖 Text-based problem categories (fallback)
- [ ] 🤖 Voice assistant launch (Google Assistant / Siri)

**Deliverable:** Full feature set complete

### Phase 4: Polish (Week 7-8)
**Goal:** Delightful user experience

- [ ] Orchid variety presets
- [ ] Care history view
- [ ] Settings screen
- [ ] App theming (green/natural)
- [ ] Empty states & onboarding
- [ ] Photo management
- [ ] Bug fixes & testing

**Deliverable:** App ready for personal use / beta testing

### Phase 5: Advanced (Future)
- [ ] Statistics & insights
- [ ] Seasonal reminders
- [ ] Health tracking
- [ ] Backup/restore
- [ ] Home screen widgets
- [ ] iOS support

---

## 8. What We're Reusing from MDAlarm

### Direct Copy (minimal changes)
| Component | Changes Needed |
|-----------|---------------|
| `permission_service.dart` | None |
| `permission_screen.dart` | Update branding |
| `permission_setup_screen.dart` | Update branding |
| `notification_service.dart` | Update channel names |
| `AlarmReceiver.kt` | None |
| `BootReceiver.kt` | None |
| `NotificationActionReceiver.kt` | Update action names |
| `AndroidManifest.xml` permissions | Update package name |
| `app_theme.dart` | Change colors to green |
| `empty_state.dart` | Change copy |

### Adapt (structural changes)
| MDAlarm | OrchidCare | Changes |
|---------|------------|---------|
| `Patient` model | `Orchid` model | Add variety, bloom status |
| `Medication` model | `CareTask` model | interval-based, not time-based |
| `DoseLog` model | `CareLog` model | Same structure |
| `patient_service.dart` | `orchid_service.dart` | Rename methods |
| `medication_service.dart` | `care_service.dart` | Change scheduling logic |
| `today_screen.dart` | `today_screen.dart` | Different grouping |

### Build New
- Orchid variety presets with default care schedules
- Interval-based scheduling (every X days vs. fixed times)
- Bloom status tracking
- Photo timeline
- Seasonal adjustment logic
- **🆕 Lux meter service** (light sensor integration)
- **🆕 AI handoff service** (photo + text to Google Lens/ChatGPT/Gemini/Siri)
- **🆕 Demo data** (sample orchid for new users)
- **🆕 Variety presets data** (care recommendations per variety)

---

## 9. Decisions Summary ✅

All key decisions have been made:

| Question | Decision |
|----------|----------|
| App Name | **OrchidLife** |
| Phase 1 Scope | All care types + Lux meter + Voice assistant |
| Notification Style | User configurable |
| Demo Data | Include sample orchid |
| Color Scheme | Green/natural theme |

---

## 10. Next Steps

Once you've reviewed this plan and answered the questions above, here's what we'll do:

1. **Finalize decisions** on name, scope, and style
2. **Create project scaffold** with folder structure
3. **Build data models** (Orchid, CareTask, CareLog)
4. **Set up database** (Isar configuration)
5. **Build first screen** (Add Orchid)
6. **Iterate from there**

---

## Appendix A: Orchid Care Quick Reference

For building the variety presets:

| Variety | Water | Fertilize | Light | Notes |
|---------|-------|-----------|-------|-------|
| Phalaenopsis | 7-10 days | Monthly | Indirect | Most forgiving |
| Dendrobium | 5-7 days | Bi-weekly | Bright | Needs dry period |
| Cattleya | 7 days | Bi-weekly | Bright | Let dry between |
| Oncidium | 5-7 days | Bi-weekly | Bright | Dancing ladies |
| Vanda | Daily (roots) | Weekly | Very bright | High maintenance |
| Paphiopedilum | 5-7 days | Monthly | Low-medium | No direct sun |
| Cymbidium | 7 days | Bi-weekly | Bright | Cool nights help |

---

## Appendix B: Comparison with MDAlarm

| Aspect | MDAlarm | OrchidLife |
|--------|---------|------------|
| Purpose | Medication reminders | Plant care reminders |
| Users | Caregivers, patients | Plant enthusiasts |
| Timing | Exact times (8:00 AM) | Intervals (every 7 days) |
| Urgency | High (health critical) | Medium (plants are forgiving-ish) |
| Complexity | Multiple patients | Multiple orchids |
| Notifications | Must be reliable | Should be reliable |
| Tone | Clinical, serious | Warm, encouraging |
| Special Features | Escalating alarms | Lux meter, Photo AI handoff |

---

*Document created by Claude for Derrick's OrchidLife project*
*Last updated: January 31, 2026*
