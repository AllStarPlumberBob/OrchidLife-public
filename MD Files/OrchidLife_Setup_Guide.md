# 🌿 OrchidLife - Getting Started Guide

## For Derrick (Complete Beginner Edition)

This guide will walk you through setting up your development environment and creating the OrchidLife project. Don't worry - I'll explain everything!

---

## What We're Setting Up

```
Your Computer
     │
     ├── Flutter SDK (the framework that builds the app)
     │
     ├── Android Studio (the coding environment)
     │        │
     │        ├── Android SDK (tools to build Android apps)
     │        │
     │        └── Android Emulator (fake phone to test on)
     │
     └── OrchidLife Project (your app!)
```

---

## Step 1: Install Flutter

Flutter is the framework we're using (same as MDAlarm). It lets us write one codebase that works on Android and iOS.

### On Windows:

1. **Download Flutter**
   - Go to: https://docs.flutter.dev/get-started/install/windows
   - Click "Download Flutter SDK"
   - Extract the zip to `C:\src\flutter` (or wherever you prefer)

2. **Add Flutter to PATH**
   - Search "Environment Variables" in Windows
   - Click "Environment Variables"
   - Under "User variables", find "Path", click Edit
   - Click "New" and add: `C:\src\flutter\bin`
   - Click OK to save

3. **Verify Installation**
   - Open Command Prompt (or PowerShell)
   - Type: `flutter --version`
   - You should see Flutter version info

### On Mac:

1. **Download Flutter**
   - Go to: https://docs.flutter.dev/get-started/install/macos
   - Download the SDK for your chip (Apple Silicon or Intel)
   - Extract to your home folder: `~/development/flutter`

2. **Add Flutter to PATH**
   - Open Terminal
   - Run: `nano ~/.zshrc` (or `~/.bashrc` if using bash)
   - Add this line: `export PATH="$PATH:$HOME/development/flutter/bin"`
   - Save (Ctrl+X, then Y, then Enter)
   - Run: `source ~/.zshrc`

3. **Verify Installation**
   - In Terminal, type: `flutter --version`

---

## Step 2: Install Android Studio

Android Studio is where you'll write code and test the app.

1. **Download Android Studio**
   - Go to: https://developer.android.com/studio
   - Click "Download Android Studio"
   - Run the installer

2. **During Installation, make sure to install:**
   - ✅ Android SDK
   - ✅ Android SDK Command-line Tools
   - ✅ Android SDK Build-Tools
   - ✅ Android Emulator

3. **First Launch Setup**
   - Open Android Studio
   - It will download additional components (this takes a while)
   - Choose "Standard" installation when asked

4. **Install Flutter Plugin**
   - In Android Studio: File → Settings (or Preferences on Mac)
   - Go to Plugins
   - Search for "Flutter"
   - Click Install (it will also install Dart plugin)
   - Restart Android Studio

---

## Step 3: Run Flutter Doctor

This checks if everything is set up correctly.

1. Open Terminal (Mac) or Command Prompt (Windows)

2. Run:
   ```
   flutter doctor
   ```

3. You should see something like:
   ```
   Doctor summary (to see all details, run flutter doctor -v):
   [✓] Flutter (Channel stable, 3.x.x)
   [✓] Android toolchain - develop for Android devices
   [✓] Android Studio (version 2024.x)
   [✓] Connected device (1 available)
   ```

4. **If you see [✗] or [!] marks:**
   - Read the message - Flutter tells you exactly what's missing
   - Common fixes:
     - "Android licenses not accepted" → Run: `flutter doctor --android-licenses`
     - "cmdline-tools missing" → Open Android Studio → SDK Manager → SDK Tools → Install "Android SDK Command-line Tools"

---

## Step 4: Create the OrchidLife Project

Now the fun part - creating your app!

### Option A: Using Command Line (Recommended)

1. Open Terminal/Command Prompt

2. Navigate to where you want your project:
   ```
   cd ~/Projects
   ```
   (or `cd C:\Projects` on Windows)

3. Create the Flutter project:
   ```
   flutter create --org com.orchidlife orchidlife
   ```
   
   This creates:
   - `com.orchidlife.orchidlife` as your app's unique ID
   - A folder called `orchidlife` with all the starter files

4. Open it in Android Studio:
   ```
   cd orchidlife
   ```
   Then: File → Open in Android Studio, select the `orchidlife` folder

### Option B: Using Android Studio

1. Open Android Studio
2. Click "New Flutter Project"
3. Select "Flutter" on the left
4. Set Flutter SDK path (where you installed it)
5. Click Next
6. Project name: `orchidlife`
7. Organization: `com.orchidlife`
8. Click Create

---

## Step 5: Set Up an Android Emulator (Virtual Phone)

You need something to run the app on. You can use a real phone OR an emulator.

### Create an Emulator:

1. In Android Studio: Tools → Device Manager
2. Click "Create Device"
3. Select a phone (e.g., "Pixel 7")
4. Click Next
5. Select a system image:
   - Choose one with "API 34" (Android 14)
   - Click "Download" if needed
6. Click Next → Finish

### Start the Emulator:

1. In Device Manager, click the ▶️ Play button next to your device
2. Wait for it to boot (first time takes a while)

### OR Use Your Real Phone:

1. On your Android phone:
   - Go to Settings → About Phone
   - Tap "Build Number" 7 times (enables Developer Mode)
   - Go back to Settings → Developer Options
   - Enable "USB Debugging"

2. Connect your phone via USB cable

3. When prompted on your phone, allow USB debugging

4. In Android Studio, your phone should appear in the device dropdown

---

## Step 6: Run the Default App (Test Your Setup)

Let's make sure everything works before we add our code.

1. In Android Studio, make sure your emulator/phone is selected in the toolbar

2. Click the green ▶️ Run button (or press Shift+F10)

3. Wait for it to build and install

4. You should see the default Flutter demo app with a counter!

**If it works: 🎉 You're ready!**

**If it doesn't work:**
- Check `flutter doctor` for issues
- Make sure an emulator is running OR phone is connected
- Try: `flutter clean` then run again

---

## Step 7: Let Me Know You're Ready!

Once you've completed steps 1-6, come back and tell me:

1. ✅ "Flutter is installed" (flutter doctor shows all green)
2. ✅ "Android Studio is set up" (with Flutter plugin)
3. ✅ "Project created" (orchidlife folder exists)
4. ✅ "Emulator/phone works" (default app runs)

Then I'll give you all the code files to replace the defaults with our OrchidLife app!

---

## What Happens Next

Once you're set up, here's how we'll work together:

```
┌─────────────────────────────────────────────────────────┐
│                    OUR WORKFLOW                         │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  1. I create code files                                 │
│            ↓                                            │
│  2. You copy them into your project                     │
│            ↓                                            │
│  3. You run the app to test                             │
│            ↓                                            │
│  4. You tell me what works / what's broken              │
│            ↓                                            │
│  5. We iterate until it's perfect!                      │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

I'll provide:
- Complete code files (just copy-paste)
- Explanations of what each file does
- Instructions on where to put them
- Help debugging any issues

You'll need to:
- Copy files into the right folders
- Run the app
- Test features
- Tell me what's happening

---

## Troubleshooting Common Issues

### "Flutter command not found"
→ Flutter isn't in your PATH. Revisit Step 1.

### "No devices available"
→ Start an emulator OR connect a phone with USB debugging enabled.

### "Gradle build failed"
→ Usually a network issue downloading dependencies. Try:
```
cd android
./gradlew clean
cd ..
flutter pub get
flutter run
```

### "SDK not found"
→ Open Android Studio → File → Project Structure → Make sure SDK path is set.

### App runs but crashes immediately
→ Check the "Run" tab in Android Studio for error messages. Share them with me!

---

## Estimated Time

| Step | Time |
|------|------|
| Download Flutter | 5-10 min |
| Install Android Studio | 15-30 min (lots of downloads) |
| First-time setup/downloads | 10-20 min |
| Create project | 2 min |
| Set up emulator | 5-10 min |
| Run test app | 2-5 min |
| **Total** | **45-90 min** |

Take your time - getting the environment right is the hardest part. Once it's done, you never have to do it again!

---

## Quick Reference Commands

```bash
# Check if Flutter is working
flutter doctor

# Create new project
flutter create --org com.orchidlife orchidlife

# Get dependencies (after editing pubspec.yaml)
flutter pub get

# Generate Isar database code (after creating models)
flutter pub run build_runner build

# Run the app
flutter run

# Clean and rebuild (when things are weird)
flutter clean
flutter pub get
flutter run

# Build release APK
flutter build apk
```

---

Good luck! Come back when you're ready, and we'll start building OrchidLife! 🌿

