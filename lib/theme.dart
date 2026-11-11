import 'package:flutter/material.dart';

/// Ranglar
class C {
  static const primary = Color(0xFF111111);
  static const bg = Color(0xFFF5F5F7);
  static const accent = Color(0xFF2F80ED);
  static const star = Color(0xFFF5B301);
  static const red = Color(0xFFE53935);
  static const green = Color(0xFF2E9E5B);
  static const grey = Color(0xFF6B6B6B);
  static const hint = Color(0xFF9A9A9A);
  static const line = Color(0xFFE6E6E8);
}

/// Tipografiya
class T {
  static const title = TextStyle(fontSize: 24, height: 32 / 24, fontWeight: FontWeight.w700, color: C.primary);
  static const heading = TextStyle(fontSize: 18, height: 24 / 18, fontWeight: FontWeight.w600, color: C.primary);
  static const sub = TextStyle(fontSize: 16, height: 22 / 16, fontWeight: FontWeight.w500, color: C.primary);
  static const body = TextStyle(fontSize: 14, height: 20 / 14, color: C.primary);
  static const name = TextStyle(fontSize: 13, height: 18 / 13, fontWeight: FontWeight.w500, color: C.primary);
  static const caption = TextStyle(fontSize: 12, height: 16 / 12, color: C.grey);
  static const price = TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: C.primary);
}

ThemeData appTheme() => ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(seedColor: C.primary).copyWith(primary: C.primary, surface: Colors.white),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: C.primary,
        titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: C.primary),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: C.primary,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
