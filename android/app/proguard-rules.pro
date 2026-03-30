# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Drift / SQLite
-keep class org.sqlite.** { *; }
-keep class sqlite3.** { *; }

# flutter_local_notifications
-keep class com.dexterous.** { *; }

# Keep annotations
-keepattributes *Annotation*

# Google Play Core — excluded from the build via configurations.all in build.gradle.kts.
# This -dontwarn is required so R8 does not error on any stale references left by
# transitive Flutter plugin code that mentions these classes.
-dontwarn com.google.android.play.core.**
