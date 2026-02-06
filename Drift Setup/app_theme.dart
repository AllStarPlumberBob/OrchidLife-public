import 'package:flutter/material.dart';

class AppTheme {
  // Brand colors - Natural greens
  static const Color primaryGreen = Color(0xFF2E7D32);      // Forest green
  static const Color primaryGreenLight = Color(0xFF4CAF50); // Leaf green
  static const Color primaryGreenDark = Color(0xFF1B5E20);  // Deep forest
  
  static const Color accentGold = Color(0xFFFFB300);        // Warm gold (for accents)
  static const Color earthBrown = Color(0xFF5D4037);        // Pot/soil brown
  
  // Semantic colors
  static const Color waterBlue = Color(0xFF1976D2);         // Water tasks
  static const Color fertilizerOrange = Color(0xFFE65100);  // Fertilize tasks
  static const Color mistCyan = Color(0xFF00ACC1);          // Misting tasks
  static const Color inspectPurple = Color(0xFF7B1FA2);     // Inspection tasks
  static const Color repotBrown = Color(0xFF6D4C41);        // Repotting tasks
  static const Color pruneRed = Color(0xFFC62828);          // Pruning tasks
  
  // Background colors
  static const Color backgroundLight = Color(0xFFF5F7F5);   // Slightly green-tinted white
  static const Color surfaceLight = Colors.white;
  static const Color backgroundDark = Color(0xFF1A1C1A);
  static const Color surfaceDark = Color(0xFF2D302D);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        brightness: Brightness.light,
        primary: primaryGreen,
        secondary: primaryGreenLight,
        surface: surfaceLight,
      ),
      scaffoldBackgroundColor: backgroundLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryGreenLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: primaryGreen,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreenLight,
        brightness: Brightness.dark,
        primary: primaryGreenLight,
        secondary: primaryGreen,
        surface: surfaceDark,
      ),
      scaffoldBackgroundColor: backgroundDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceDark,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryGreenLight,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        color: surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryGreenLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryGreenLight, width: 2),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: primaryGreenLight,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

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
