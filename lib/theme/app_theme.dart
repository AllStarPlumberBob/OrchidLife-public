// lib/theme/app_theme.dart
// OrchidLife - Sage & Mint Theme (Soft Material 3)

import 'package:flutter/material.dart';

class AppTheme {
  // ══════════════════════════════════════════════════════════════════════════
  // PRIMARY COLORS — Sage & Mint palette
  // ══════════════════════════════════════════════════════════════════════════

  static const Color primary = Color(0xFF7C9A72); // Muted sage green
  static const Color primaryLight = Color(0xFFA8C5A0); // Soft sage
  static const Color primaryDark = Color(0xFF5B7A52); // Deeper sage

  // Aliases used by Drift screens
  static const Color primaryGreen = primary;
  static const Color primaryGreenLight = primaryLight;
  static const Color primaryGreenDark = primaryDark;

  // ══════════════════════════════════════════════════════════════════════════
  // SECONDARY/ACCENT
  // ══════════════════════════════════════════════════════════════════════════

  static const Color secondary = Color(0xFF8D6E63); // Warm Brown
  static const Color accent = Color(0xFFFFB74D); // Soft Orange
  static const Color mintAccent = Color(0xFFB2DFDB); // Mint accent

  // ══════════════════════════════════════════════════════════════════════════
  // BACKGROUNDS
  // ══════════════════════════════════════════════════════════════════════════

  static const Color background = Color(0xFFF7F5F0); // Warm cream/linen
  static const Color surface = Color(0xFFFEFDFB); // Warm off-white
  static const Color surfaceVariant = Color(0xFFEFF2EC); // Light sage tint

  // ══════════════════════════════════════════════════════════════════════════
  // CARD
  // ══════════════════════════════════════════════════════════════════════════

  static const Color cardBackground = Color(0xFFFEFDFB); // Warm off-white
  static const Color cardBorder = Color(0xFFE3E0DB); // Warm gray border

  // ══════════════════════════════════════════════════════════════════════════
  // SLIVER / FLOATING NAV
  // ══════════════════════════════════════════════════════════════════════════

  static const Color sliverGradientStart = Color(0xFF7C9A72);
  static const Color sliverGradientEnd = Color(0xFF9AB892);
  static const Color floatingNavBackground = Color(0xFFFEFDFB);

  // ══════════════════════════════════════════════════════════════════════════
  // TEXT
  // ══════════════════════════════════════════════════════════════════════════

  static const Color textPrimary = Color(0xFF2D2D2D); // Warmer near-black
  static const Color textSecondary = Color(0xFF7A8B7C); // Muted sage-gray
  static const Color textOnPrimary = Color(0xFFFFFFFF); // White

  // ══════════════════════════════════════════════════════════════════════════
  // STATUS COLORS (softened)
  // ══════════════════════════════════════════════════════════════════════════

  static const Color statusNeedsCare = Color(0xFFEDA04A); // Soft orange
  static const Color statusOverdue = Color(0xFFD95555); // Soft red
  static const Color statusCompleted = Color(0xFF6BA86E); // Soft green
  static const Color statusUpcoming = Color(0xFF6BAFE5); // Soft blue
  static const Color statusSkipped = Color(0xFF9E9E9E); // Gray

  // ══════════════════════════════════════════════════════════════════════════
  // SPECIAL
  // ══════════════════════════════════════════════════════════════════════════

  static const Color bloom = Color(0xFFE91E63); // Pink - flowering status
  static const Color luxHigh = Color(0xFFFFF176); // Yellow - bright light
  static const Color luxLow = Color(0xFF90A4AE); // Blue-gray - low light

  // ══════════════════════════════════════════════════════════════════════════
  // CARE TYPE COLORS (softened ~15%)
  // ══════════════════════════════════════════════════════════════════════════

  static const Color waterBlue = Color(0xFF5C9ACE);
  static const Color fertilizerOrange = Color(0xFFD4854A);
  static const Color mistCyan = Color(0xFF4DB8C7);
  static const Color inspectPurple = Color(0xFF9565AC);
  static const Color repotBrown = Color(0xFF8B6B5E);
  static const Color pruneRed = Color(0xFFC45B5B);

  // ══════════════════════════════════════════════════════════════════════════
  // DIVIDER
  // ══════════════════════════════════════════════════════════════════════════

  static const Color divider = Color(0xFFE3E0DB); // Warm gray

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
  // RADIUS (softened)
  // ══════════════════════════════════════════════════════════════════════════

  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  static const double radiusCard = 16.0;
  static const double radiusFull = 100.0;

  // ══════════════════════════════════════════════════════════════════════════
  // SLIVER APP BAR / FLOATING NAV CONSTANTS
  // ══════════════════════════════════════════════════════════════════════════

  static const double sliverExpandedHeight = 140.0;
  static const double floatingNavMarginH = 16.0;
  static const double floatingNavMarginB = 16.0;
  static const double floatingNavRadius = 24.0;

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
        primaryContainer: primaryLight.withValues(alpha: 0.2),
        secondary: secondary,
        secondaryContainer: secondary.withValues(alpha: 0.2),
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
          fontSize: 34,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          letterSpacing: -0.3,
        ),
        displayMedium: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          letterSpacing: -0.3,
        ),
        headlineLarge: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          letterSpacing: -0.3,
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: -0.3,
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

      // App Bar — transparent for SliverAppBar pattern
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: textOnPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textOnPrimary,
        ),
      ),

      // Card — soft elevation, warm background, subtle border
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusCard),
          side: const BorderSide(color: cardBorder, width: 0.5),
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

      // Bottom Navigation Bar (legacy fallback)
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Navigation Bar (Material 3) — used inside floating nav
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        indicatorColor: Colors.white.withValues(alpha: 0.2),
        indicatorShape: const StadiumBorder(),
        height: 64,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: Colors.white, size: 24);
          }
          return IconThemeData(color: Colors.white.withValues(alpha: 0.7), size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            );
          }
          return TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: Colors.white.withValues(alpha: 0.7),
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
        selectedColor: primaryLight.withValues(alpha: 0.3),
        labelStyle: const TextStyle(
          fontSize: 14,
          color: textPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusFull),
        ),
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
      ),

      // Scaffold
      scaffoldBackgroundColor: background,
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // DARK THEME — Dark sage tones
  // ══════════════════════════════════════════════════════════════════════════

  static ThemeData get darkTheme {
    const darkSurface = Color(0xFF1A1C1A);
    const darkCard = Color(0xFF242624);
    const darkBackground = Color(0xFF121412);
    const darkTextPrimary = Color(0xFFE0E0E0);

    return ThemeData.dark(useMaterial3: true).copyWith(
      colorScheme: const ColorScheme.dark().copyWith(
        primary: primaryLight,
        secondary: secondary,
        surface: darkSurface,
        error: statusOverdue,
      ),
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: darkCard,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusCard),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.08), width: 0.5),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        indicatorColor: Colors.white.withValues(alpha: 0.2),
        indicatorShape: const StadiumBorder(),
        height: 64,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: Colors.white, size: 24);
          }
          return IconThemeData(color: Colors.white.withValues(alpha: 0.7), size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            );
          }
          return TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: Colors.white.withValues(alpha: 0.7),
          );
        }),
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
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: darkTextPrimary, letterSpacing: -0.3),
        displayMedium: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: darkTextPrimary, letterSpacing: -0.3),
        headlineLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: darkTextPrimary, letterSpacing: -0.3),
        headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: darkTextPrimary, letterSpacing: -0.3),
        headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: darkTextPrimary),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: darkTextPrimary),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: darkTextPrimary),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: darkTextPrimary),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: darkTextPrimary),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: darkTextPrimary, letterSpacing: 0.1),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // CARE TYPE HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  /// Get color for a care type
  static Color getCareTypeColor(String careType) {
    switch (careType.toLowerCase()) {
      case 'water':
        return waterBlue;
      case 'fertilize':
        return fertilizerOrange;
      case 'mist':
        return mistCyan;
      case 'inspect':
        return inspectPurple;
      case 'repot':
        return repotBrown;
      case 'prune':
        return pruneRed;
      default:
        return primaryGreen;
    }
  }

  /// Get icon for a care type
  static IconData getCareTypeIcon(String careType) {
    switch (careType.toLowerCase()) {
      case 'water':
        return Icons.water_drop;
      case 'fertilize':
        return Icons.eco;
      case 'mist':
        return Icons.grain;
      case 'inspect':
        return Icons.search;
      case 'repot':
        return Icons.yard;
      case 'prune':
        return Icons.content_cut;
      default:
        return Icons.task_alt;
    }
  }

  /// Get display name for a care type
  static String getCareTypeDisplayName(String careType) {
    switch (careType.toLowerCase()) {
      case 'water':
        return 'Water';
      case 'fertilize':
        return 'Fertilize';
      case 'mist':
        return 'Mist';
      case 'inspect':
        return 'Inspect';
      case 'repot':
        return 'Repot';
      case 'prune':
        return 'Prune';
      default:
        return careType;
    }
  }
}
