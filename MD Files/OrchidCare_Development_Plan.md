# 🌸 OrchidCare App - Development Plan

## Document Info
- **Version:** 1.0
- **Created:** January 31, 2026
- **Based on:** MDAlarm codebase (Flutter/Dart)
- **Target Platform:** Android 14+ (iOS possible later)

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
| **Care Tasks** | Define watering, fertilizing, misting schedules | Medication scheduling |
| **Smart Reminders** | Reliable notifications that work when app is closed | Full notification system |
| **Care Logging** | Record when you water/fertilize/etc. | DoseLog system |
| **Today View** | See what needs care today | TodayScreen |

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
orchidcare/
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
│   │   └── care_log.dart            # Care history model
│   ├── services/
│   │   ├── database_service.dart    # Isar setup
│   │   ├── orchid_service.dart      # CRUD for orchids
│   │   ├── care_service.dart        # Care task management
│   │   ├── notification_service.dart # Push notifications
│   │   ├── alarm_service.dart       # Schedule alarms
│   │   └── permission_service.dart  # Handle permissions
│   ├── screens/
│   │   ├── today_screen.dart        # Main "what needs care" view
│   │   ├── orchid_list_screen.dart  # All orchids grid
│   │   ├── orchid_detail_screen.dart
│   │   ├── add_edit_orchid_screen.dart
│   │   ├── care_history_screen.dart
│   │   └── settings_screen.dart
│   ├── widgets/
│   │   ├── orchid_card.dart
│   │   ├── care_task_tile.dart
│   │   ├── care_action_buttons.dart
│   │   └── empty_state.dart
│   ├── theme/
│   │   └── app_theme.dart           # Colors, typography
│   └── utils/
│       └── text_utils.dart
└── pubspec.yaml                     # Dependencies
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

---

## 5. User Interface Design

### Design Principles
1. **Calming & Natural** - Soft greens, earthy tones (not clinical like MDAlarm)
2. **Visual First** - Big orchid photos, minimal text
3. **Quick Actions** - One tap to mark as watered
4. **Forgiving** - Easy to undo, snooze, or skip

### Color Palette
```
Primary:      #4CAF50  (Fresh Green)
Secondary:    #8BC34A  (Light Green)
Accent:       #FF9800  (Warm Orange - for alerts)
Background:   #FAFAFA  (Off-white)
Surface:      #FFFFFF  (White cards)
Text:         #212121  (Near black)
TextSecondary:#757575  (Gray)

Status Colors:
- Needs Care: #FF9800 (Orange)
- All Good:   #4CAF50 (Green)
- Overdue:    #F44336 (Red)
- Upcoming:   #2196F3 (Blue)
```

### Key Screens

#### 1. Today Screen (Home)
```
┌────────────────────────────────────┐
│  ☀️ Good Morning!                  │
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
- [ ] Database models (Orchid, CareTask, CareLog)
- [ ] Database service (Isar setup)
- [ ] Add/Edit Orchid screen
- [ ] Orchid list screen
- [ ] Basic notification service
- [ ] Permission handling (copy from MDAlarm)

**Deliverable:** Can add orchids and receive test notifications

### Phase 2: Core Features (Week 3-4)
**Goal:** Fully functional care tracking

- [ ] Care task scheduling
- [ ] Today screen with due tasks
- [ ] Quick actions (Done/Skip/Snooze)
- [ ] Care logging
- [ ] Orchid detail screen
- [ ] Alarm scheduling (Android native)
- [ ] Boot receiver (survive restarts)

**Deliverable:** Complete daily care workflow

### Phase 3: Polish (Week 5-6)
**Goal:** Delightful user experience

- [ ] Orchid variety presets
- [ ] Care history view
- [ ] Settings screen
- [ ] App theming (green/natural)
- [ ] Empty states & onboarding
- [ ] Photo management
- [ ] Bug fixes & testing

**Deliverable:** App ready for personal use

### Phase 4: Advanced (Future)
- [ ] Statistics & insights
- [ ] Seasonal reminders
- [ ] Health tracking
- [ ] Backup/restore
- [ ] Widgets

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

---

## 9. Questions to Decide

Before we start building, let's decide on a few things:

### 1. App Name
Options:
- **OrchidCare** (simple, clear)
- **Orchid Keeper** (sounds like a guardian)
- **Bloom Buddy** (friendly, casual)
- **Orchid Journal** (emphasizes tracking)
- Something else?

### 2. Initial Scope
Should Phase 1 include:
- [ ] Just one care type (watering only)?
- [ ] All care types from the start?
- [ ] Orchid variety presets or manual entry only?

### 3. Notification Style
- Gentle (once a day, easy to dismiss)
- Persistent (keeps reminding until done)
- Configurable (user chooses)

### 4. Data
- Start with empty app (user adds everything)
- Include a sample orchid to show how it works
- Include variety database with care tips

### 5. Branding
- Color scheme preference? (I suggested greens)
- Any icon ideas?
- Tone: Professional or casual/fun?

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

| Aspect | MDAlarm | OrchidCare |
|--------|---------|------------|
| Purpose | Medication reminders | Plant care reminders |
| Users | Caregivers, patients | Plant enthusiasts |
| Timing | Exact times (8:00 AM) | Intervals (every 7 days) |
| Urgency | High (health critical) | Medium (plants are forgiving-ish) |
| Complexity | Multiple patients | Multiple orchids |
| Notifications | Must be reliable | Should be reliable |
| Tone | Clinical, serious | Warm, encouraging |

---

*Document created by Claude for Derrick's OrchidCare project*
