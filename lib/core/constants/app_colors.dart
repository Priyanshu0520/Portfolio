import 'package:flutter/material.dart';

/// App color palette - Chocolate Brown & Beige Theme
class AppColors {
  AppColors._();

  // Primary Colors - Chocolate Brown
  static const Color primary = Color(0xFF5D4037); // Rich Chocolate Brown
  static const Color primaryDark = Color(0xFF3E2723); // Dark Chocolate
  static const Color primaryLight = Color(0xFF8D6E63); // Light Brown

  // Secondary Colors - Beige
  static const Color secondary = Color(0xFFD7CCC8); // Soft Beige
  static const Color secondaryDark = Color(0xFFBCAAA4); // Warm Beige
  static const Color secondaryLight = Color(0xFFEFEBE9); // Light Beige

  // Background Colors
  static const Color background = Color(0xFFFAF8F6); // Creamy White
  static const Color surface = Color(0xFFFFFFFF); // Pure White
  static const Color card = Color(0xFFFFF8F5); // Warm White

  // Text Colors
  static const Color textPrimary = Color(0xFF3E2723); // Dark Brown
  static const Color textSecondary = Color(0xFF6D4C41); // Medium Brown
  static const Color textTertiary = Color(0xFF8D6E63); // Light Brown

  // Accent Colors
  static const Color accent = Color(0xFFA1887F); // Warm Grey-Brown
  static const Color success = Color(0xFF7CB342); // Olive Green
  static const Color warning = Color(0xFFFFB74D); // Warm Orange
  static const Color error = Color(0xFFD84315); // Terracotta Red
  static const Color info = Color(0xFF8D6E63); // Brown Info

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFFBCAAA4);
  static const Color greyLight = Color(0xFFEFEBE9);
  static const Color greyDark = Color(0xFF6D4C41);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondaryLight, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFFFFF8F5), Color(0xFFEFEBE9)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
