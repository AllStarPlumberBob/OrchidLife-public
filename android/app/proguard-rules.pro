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

# Google Play Core (not available in F-Droid builds)
-dontwarn com.google.android.play.core.**

