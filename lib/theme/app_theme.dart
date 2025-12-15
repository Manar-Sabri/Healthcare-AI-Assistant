import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Blue Professional Palette
  static const Color primary = Color(0xFF007BFF); 
  static const Color accent = Color(0xFF1A73E8); 
  static const Color background = Color(0xFFF4F8FF);
  static const Color surface = Colors.white;
  
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF2E7D32);

  // Shadows
  static const Color shadowLight = Colors.white;
  static const Color shadowDark = Color(0xFFA0AEC0);

  // ThemeData
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primary,
    scaffoldBackgroundColor: background,
    
    colorScheme: const ColorScheme.light(
      primary: primary,
      secondary: accent, 
      surface: surface,
      background: background,
      error: error,
    ),

    textTheme: GoogleFonts.cairoTextTheme(ThemeData.light().textTheme).apply(
      bodyColor: textPrimary,
      displayColor: textPrimary,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: primary, size: 28),
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Cairo',
      ),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primary,
    scaffoldBackgroundColor: const Color(0xFF0F172A),
    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: accent,
      surface: Color(0xFF1E293B),
      background: Color(0xFF0F172A),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme),
  );
}
