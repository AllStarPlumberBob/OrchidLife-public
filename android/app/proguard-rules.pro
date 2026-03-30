# Drift / SQLite
-keep class org.sqlite.** { *; }
-keep class sqlite3.** { *; }

# flutter_local_notifications
-keep class com.dexterous.** { *; }

# Keep annotations
-keepattributes *Annotation*

# Google Play Core — the F-Droid fdroiddata build recipe patches the Flutter Gradle
# plugin's flutter_release.pro to exclude PlayStoreDeferredComponentManager (the class
# that implements Play Core interfaces) from the broad io.flutter.** keep rule.
# This lets R8 strip the entire deferred-components chain from the APK.
# The -dontwarn below silences any residual missing-class warnings during the R8 pass.
-dontwarn com.google.android.play.core.**

# Suppress warnings if R8 encounters stripped deferred-component class references.
-dontwarn io.flutter.embedding.engine.deferredcomponents.**
