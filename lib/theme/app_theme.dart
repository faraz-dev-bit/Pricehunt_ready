// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Backgrounds
  static const bg        = Color(0xFF0A0A0F);
  static const surface   = Color(0xFF13131C);
  static const card      = Color(0xFF1A1A28);
  static const border    = Color(0x12FFFFFF);

  // Brand
  static const primary   = Color(0xFFFF6B2B);
  static const primaryGlow = Color(0x20FF6B2B);
  static const secondary = Color(0xFFFFB347);

  // Status
  static const success   = Color(0xFF2DFF9C);
  static const successGlow = Color(0x1A2DFF9C);
  static const info      = Color(0xFF4F8EFF);
  static const infoGlow  = Color(0x1A4F8EFF);
  static const purple    = Color(0xFFC084FC);
  static const purpleGlow= Color(0x1AC084FC);

  // Text
  static const textPrimary   = Color(0xFFF0F0FF);
  static const textSecondary = Color(0xFFA0A0C8);
  static const textMuted     = Color(0xFF606090);

  // Platforms
  static const amazon   = Color(0xFFFF9900);
  static const amazonBg = Color(0x26FF9900);
  static const flipkart = Color(0xFF4F8EFF);
  static const flipkartBg = Color(0x264F8EFF);
  static const meesho   = Color(0xFFC084FC);
  static const meeshoBg = Color(0x26C084FC);
}

class AppTheme {
  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bg,
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.dark(
      primary:   AppColors.primary,
      secondary: AppColors.secondary,
      surface:   AppColors.surface,
      background:AppColors.bg,
    ),
    textTheme: GoogleFonts.dmSansTextTheme(
      ThemeData.dark().textTheme,
    ).apply(
      bodyColor:      AppColors.textPrimary,
      displayColor:   AppColors.textPrimary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bg,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.textPrimary),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor:      AppColors.surface,
      selectedItemColor:    AppColors.primary,
      unselectedItemColor:  AppColors.textMuted,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
  );
}
