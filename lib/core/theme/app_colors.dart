import 'package:flutter/material.dart';

/// App color palette for Going50.
///
/// This class defines all the colors used in the application.
class AppColors {
  // Primary brand colors
  static const Color primary = Color(0xFF4CAF50); // Green
  static const Color primaryLight = Color(0xFF80E27E);
  static const Color primaryDark = Color(0xFF087F23);
  
  // Secondary accent colors
  static const Color secondary = Color(0xFF03A9F4); // Blue
  static const Color secondaryLight = Color(0xFF67DAFF);
  static const Color secondaryDark = Color(0xFF007AC1);
  
  // Background colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFFF5F5F5);
  
  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFFFFFFFF);
  
  // Feedback colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF2196F3);
  
  // Neutral colors
  static const Color neutralGray = Color(0xFF9E9E9E);
  
  // Eco-score gradient colors
  static const Color ecoScoreLow = Color(0xFFE53935); // Red
  static const Color ecoScoreMedium = Color(0xFFFFB300); // Amber
  static const Color ecoScoreHigh = Color(0xFF43A047); // Green
  
  // Dark theme adjustments
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Color(0xFFEEEEEE);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  
  // Prevent instantiation
  AppColors._();
  
  /// Returns a color based on the eco-score value.
  ///
  /// [score] should be between 0 and 100.
  static Color getEcoScoreColor(double score) {
    if (score < 40) {
      return ecoScoreLow;
    } else if (score < 70) {
      return ecoScoreMedium;
    } else {
      return ecoScoreHigh;
    }
  }
} 