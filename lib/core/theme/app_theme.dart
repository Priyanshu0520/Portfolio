import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// App theme configuration - Chocolate Brown & Beige
class AppTheme {
  AppTheme._();

  // App Theme
  static ThemeData theme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      error: AppColors.error,
      tertiary: AppColors.accent,
    ),
    scaffoldBackgroundColor: AppColors.background,

    // Text Theme
    textTheme: GoogleFonts.latoTextTheme().copyWith(
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: AppSizes.font4XL,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        fontSize: AppSizes.font3XL,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      displaySmall: GoogleFonts.playfairDisplay(
        fontSize: AppSizes.fontXXL,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      headlineLarge: GoogleFonts.merriweather(
        fontSize: AppSizes.fontXL,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      headlineMedium: GoogleFonts.merriweather(
        fontSize: AppSizes.fontLG,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      bodyLarge: GoogleFonts.lato(
        fontSize: AppSizes.fontMD,
        color: AppColors.textPrimary,
      ),
      bodyMedium: GoogleFonts.lato(
        fontSize: AppSizes.fontSM,
        color: AppColors.textSecondary,
      ),
      bodySmall: GoogleFonts.lato(
        fontSize: AppSizes.fontXS,
        color: AppColors.textTertiary,
      ),
    ),

    // AppBar Theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.textPrimary,
      titleTextStyle: GoogleFonts.merriweather(
        fontSize: AppSizes.fontLG,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    ),

    // Card Theme
    cardTheme: CardTheme(
      elevation: AppSizes.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLG),
      ),
      color: AppColors.card,
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingLG,
          vertical: AppSizes.paddingMD,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMD),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: AppSizes.fontMD,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: GoogleFonts.poppins(
          fontSize: AppSizes.fontMD,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.all(AppSizes.paddingMD),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMD),
        borderSide: const BorderSide(color: AppColors.greyLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMD),
        borderSide: const BorderSide(color: AppColors.greyLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMD),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMD),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      labelStyle: GoogleFonts.lato(
        fontSize: AppSizes.fontMD,
        color: AppColors.textSecondary,
      ),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: AppColors.textPrimary,
      size: AppSizes.iconMD,
    ),
  );
}
