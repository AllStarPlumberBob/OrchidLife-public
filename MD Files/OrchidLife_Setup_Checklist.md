# OrchidLife Setup Checklist

Print this out and check off as you go!

---

## Phase 1: Install Tools

### Flutter SDK
- [ ] Download from https://docs.flutter.dev/get-started/install
- [ ] Extract to a folder (e.g., `C:\src\flutter` or `~/development/flutter`)
- [ ] Add to PATH (system environment variables)
- [ ] Open terminal, run `flutter --version` - see version number? ✓

### Android Studio  
- [ ] Download from https://developer.android.com/studio
- [ ] Install (include Android SDK, Emulator)
- [ ] Open Android Studio, let it download components
- [ ] Install Flutter plugin (Settings → Plugins → Search "Flutter")
- [ ] Restart Android Studio

### Verify Everything
- [ ] Run `flutter doctor` in terminal
- [ ] All checkmarks green? (or fix what's red)
- [ ] Accept Android licenses: `flutter doctor --android-licenses`

---

## Phase 2: Create Project

### Create OrchidLife
- [ ] Open terminal
- [ ] Navigate to your projects folder: `cd ~/Projects` (or wherever)
- [ ] Run: `flutter create --org com.orchidlife orchidlife`
- [ ] Open folder in Android Studio

### Set Up Test Device
Choose ONE:

**Option A: Emulator (Virtual Phone)**
- [ ] Android Studio → Tools → Device Manager
- [ ] Create Device → Pick Pixel 7 → Pick Android 14 (API 34)
- [ ] Click play ▶️ to start emulator

**Option B: Real Phone**
- [ ] Enable Developer Mode (tap Build Number 7 times)
- [ ] Enable USB Debugging in Developer Options
- [ ] Connect via USB
- [ ] Allow debugging when prompted

### Test Run
- [ ] In Android Studio, select your device in toolbar
- [ ] Click green Run ▶️ button
- [ ] See the default Flutter counter app?

---

## ✅ Ready for Code!

If you checked everything above, tell Claude:

> "I'm set up! Flutter doctor is green, project is created, 
> and I can run the default app on [emulator/my phone]."

Then I'll send you all the OrchidLife code files!

---

## Quick Commands Cheat Sheet

```
flutter doctor              # Check setup
flutter create orchidlife   # Create project
flutter pub get             # Install dependencies  
flutter run                 # Run app
flutter clean               # Fix weird issues
```
