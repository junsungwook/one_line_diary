import 'package:flutter/material.dart';

enum ColorTheme {
  milkGrayBlue,
  plumMilk,
  cloudSmog,
}

class ThemeColors {
  final Color lightBackground;
  final Color darkBackground;
  final Color lightSurface;
  final Color darkSurface;
  final Color lightTextPrimary;
  final Color darkTextPrimary;
  final Color lightTextSecondary;
  final Color darkTextSecondary;

  const ThemeColors({
    required this.lightBackground,
    required this.darkBackground,
    required this.lightSurface,
    required this.darkSurface,
    required this.lightTextPrimary,
    required this.darkTextPrimary,
    required this.lightTextSecondary,
    required this.darkTextSecondary,
  });
}

abstract final class AppColors {
  // 테마별 색상 정의
  static const themeColors = {
    ColorTheme.milkGrayBlue: ThemeColors(
      lightBackground: Color(0xFFFDF8F3),
      darkBackground: Color(0xFF2B323F),
      lightSurface: Color(0xFFFFFFFF),
      darkSurface: Color(0xFF3A4250),
      lightTextPrimary: Color(0xFF2B323F),
      darkTextPrimary: Color(0xFFFDF8F3),
      lightTextSecondary: Color(0xFF6B7280),
      darkTextSecondary: Color(0xFFA0A8B4),
    ),
    ColorTheme.plumMilk: ThemeColors(
      lightBackground: Color(0xFFFFF3E6),
      darkBackground: Color(0xFF381932),
      lightSurface: Color(0xFFFFFFFF),
      darkSurface: Color(0xFF4A2A42),
      lightTextPrimary: Color(0xFF381932),
      darkTextPrimary: Color(0xFFFFF3E6),
      lightTextSecondary: Color(0xFF6B5565),
      darkTextSecondary: Color(0xFFBBA8B5),
    ),
    ColorTheme.cloudSmog: ThemeColors(
      lightBackground: Color(0xFFF4F4F4),
      darkBackground: Color(0xFF5C636D),
      lightSurface: Color(0xFFFFFFFF),
      darkSurface: Color(0xFF6E757F),
      lightTextPrimary: Color(0xFF3D3D3D),
      darkTextPrimary: Color(0xFFF4F4F4),
      lightTextSecondary: Color(0xFF8A8A8A),
      darkTextSecondary: Color(0xFFB8BCC2),
    ),
  };

  // Primary - 부드러운 코랄/피치
  static const primary = Color(0xFFE8A87C);
  static const primaryLight = Color(0xFFF3C9A8);
  static const primaryDark = Color(0xFFD4896A);

  // Secondary - 차분한 세이지 그린
  static const secondary = Color(0xFF85A392);
  static const secondaryLight = Color(0xFFA8C5B5);

  // 기본 Background (fallback)
  static const backgroundLight = Color(0xFFFAFAFA);
  static const backgroundDark = Color(0xFF1A1A1A);
  static const surfaceLight = Color(0xFFFFFFFF);
  static const surfaceDark = Color(0xFF2A2A2A);
  static const cardLight = Color(0xFFFFFFFF);

  // Calendar dots
  static const dotRecorded = Color(0xFF85A392);  // 기록된 날 - 세이지 그린
  static const dotToday = Color(0xFFE8A87C);     // 오늘 - 코랄
  static const dotEmpty = Color(0xFFE8E4DF);     // 빈 날
  static const dotFuture = Color(0xFFF0EDE8);    // 미래

  // Text
  static const textPrimaryLight = Color(0xFF3D3D3D);
  static const textSecondaryLight = Color(0xFF9A9590);
  static const textPrimaryDark = Color(0xFFF5F5F5);
  static const textSecondaryDark = Color(0xFFAAAAAA);

  // Accent
  static const accent = Color(0xFFD4A574);       // 골드/카라멜

  // Status
  static const error = Color(0xFFE57373);
}
