// lib/theme/app_theme.dart
// OrchidLife - Green/Natural Theme

import 'package:flutter/material.dart';

class AppTheme {
  // ══════════════════════════════════════════════════════════════════════════
  // PRIMARY COLORS
  // ══════════════════════════════════════════════════════════════════════════
  
  static const Color primary = Color(0xFF2E7D32); // Forest Green
  static const Color primaryLight = Color(0xFF4CAF50); // Fresh Green
  static const Color primaryDark = Color(0xFF1B5E20); // Deep Green

  // ══════════════════════════════════════════════════════════════════════════
  // SECONDARY/ACCENT
  // ══════════════════════════════════════════════════════════════════════════
  
  static const Color secondary = Color(0xFF8D6E63); // Warm Brown
  static const Color accent = Color(0xFFFFB74D); // Soft Orange

  // ══════════════════════════════════════════════════════════════════════════
  // BACKGROUNDS
  // ══════════════════════════════════════════════════════════════════════════
  
  static const Color background = Color(0xFFF1F8E9); // Pale Green tint
  static const Color surface = Color(0xFFFFFFFF); // White
  static const Color surfaceVariant = Color(0xFFE8F5E9); // Light Green

  // ══════════════════════════════════════════════════════════════════════════
  // TEXT
  // ══════════════════════════════════════════════════════════════════════════
  
  static const Color textPrimary = Color(0xFF1B1B1B); // Near Black
  static const Color textSecondary = Color(0xFF5D7B5F); // Muted Green-Gray
  static const Color textOnPrimary = Color(0xFFFFFFFF); // White

  // ══════════════════════════════════════════════════════════════════════════
  // STATUS COLORS
  // ══════════════════════════════════════════════════════════════════════════
  
  static const Color statusNeedsCare = Color(0xFFFF9800); // Orange
  static const Color statusOverdue = Color(0xFFE53935); // Red
  static const Color statusCompleted = Color(0xFF43A047); // Green
  static const Color statusUpcoming = Color(0xFF42A5F5); // Blue
  static const Color statusSkipped = Color(0xFF9E9E9E); // Gray

  // ══════════════════════════════════════════════════════════════════════════
  // SPECIAL
  // ══════════════════════════════════════════════════════════════════════════
  
  static const Color bloom = Color(0xFFE91E63); // Pink - flowering status
  static const Color luxHigh = Color(0xFFFFF176); // Yellow - bright light
  static const Color luxLow = Color(0xFF90A4AE); // Blue-gray - low light

  // ══════════════════════════════════════════════════════════════════════════
  // DIVIDER
  // ══════════════════════════════════════════════════════════════════════════
  
  static const Color divider = Color(0xFFE0E0E0);

  // ══════════════════════════════════════════════════════════════════════════
  // SPACING
  // ══════════════════════════════════════════════════════════════════════════
  
  static const double spacing1 = 4.0;
  static const double spacing2 = 8.0;
  static const double spacing3 = 12.0;
  static const double spacing4 = 16.0;
  static const double spacing5 = 20.0;
  static const double spacing6 = 24.0;
  static const double spacing8 = 32.0;

  static const double screenPadding = 16.0;

  // ══════════════════════════════════════════════════════════════════════════
  // RADIUS
  // ══════════════════════════════════════════════════════════════════════════
  
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 16.0;
  static const double radiusFull = 100.0;

  // ══════════════════════════════════════════════════════════════════════════
  // SIZING
  // ══════════════════════════════════════════════════════════════════════════
  
  static const double avatarSmall = 40.0;
  static const double avatarMedium = 56.0;
  static const double avatarLarge = 80.0;
  static const double avatarDetail = 120.0;

  static const double touchTargetMin = 48.0;
  static const double touchTargetPreferred = 56.0;

  // ══════════════════════════════════════════════════════════════════════════
  // HELPER: Parse hex color
  // ══════════════════════════════════════════════════════════════════════════
  
  static Color fromHex(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ORCHID COLOR TAGS (for visual organization)
  // ══════════════════════════════════════════════════════════════════════════
  
  static const List<String> orchidColors = [
    '#4CAF50', // Green
    '#8BC34A', // Light Green
    '#CDDC39', // Lime
    '#FF9800', // Orange
    '#E91E63', // Pink
    '#9C27B0', // Purple
    '#673AB7', // Deep Purple
    '#2196F3', // Blue
    '#00BCD4', // Cyan
    '#795548', // Brown
  ];

  // ══════════════════════════════════════════════════════════════════════════
  // LIGHT THEME
  // ══════════════════════════════════════════════════════════════════════════
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: primary,
        primaryContainer: primaryLight.withOpacity(0.2),
        secondary: secondary,
        secondaryContainer: secondary.withOpacity(0.2),
        surface: surface,
        error: statusOverdue,
        onPrimary: textOnPrimary,
        onSecondary: textOnPrimary,
        onSurface: textPrimary,
        onError: textOnPrimary,
      ),
      
      // Typography
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: textPrimary,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimary,
          letterSpacing: 0.1,
        ),
      ),
      
      // App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: textOnPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textOnPrimary,
        ),
      ),
      
      // Card
      cardTheme: CardThemeData(
        color: surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 0,
          vertical: spacing2,
        ),
      ),
      
      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: textOnPrimary,
          minimumSize: const Size.fromHeight(touchTargetPreferred),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spacing6,
            vertical: spacing4,
          ),
        ),
      ),
      
      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          minimumSize: const Size.fromHeight(touchTargetPreferred),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          side: const BorderSide(color: primary),
          padding: const EdgeInsets.symmetric(
            horizontal: spacing6,
            vertical: spacing4,
          ),
        ),
      ),
      
      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          minimumSize: const Size(touchTargetMin, touchTargetMin),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSmall),
          ),
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: statusOverdue),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacing4,
          vertical: spacing4,
        ),
      ),
      
      // FAB
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: textOnPrimary,
        elevation: 4,
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Navigation Bar (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: primaryLight.withOpacity(0.3),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: primary,
            );
          }
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: textSecondary,
          );
        }),
      ),
      
      // Divider
      dividerTheme: const DividerThemeData(
        color: divider,
        thickness: 1,
        space: spacing4,
      ),
      
      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: surfaceVariant,
        selectedColor: primaryLight.withOpacity(0.3),
        labelStyle: const TextStyle(
          fontSize: 14,
          color: textPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusFull),
        ),
      ),
      
      // Scaffold
      scaffoldBackgroundColor: background,
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // DARK THEME (Basic - can be enhanced later)
  // ══════════════════════════════════════════════════════════════════════════
  
  static ThemeData get darkTheme {
    return ThemeData.dark(useMaterial3: true).copyWith(
      colorScheme: ColorScheme.dark(
        primary: primaryLight,
        secondary: secondary,
        error: statusOverdue,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryLight,
          foregroundColor: Colors.black,
          minimumSize: const Size.fromHeight(touchTargetPreferred),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
        ),
      ),
    );
  }
}
