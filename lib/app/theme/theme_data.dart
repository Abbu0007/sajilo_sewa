import 'package:flutter/material.dart';
import 'package:sajilo_sewa/core/constants/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: false,
    scaffoldBackgroundColor: const Color(0xFFF9FAFB),

    primaryColor: const Color(0xFF2563EB),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF6D5DF6),
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        fontFamily: 'Quicksand Semibold',
        fontSize: 18,
        color: Colors.white,
      ),
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      elevation: 12,
      type: BottomNavigationBarType.fixed,

      selectedItemColor: AppColors.primary,
      unselectedItemColor: Color(0xFF9CA3AF),

      selectedIconTheme: IconThemeData(color: AppColors.primary, size: 24),
      unselectedIconTheme: IconThemeData(color: Color(0xFF9CA3AF), size: 22),

      selectedLabelStyle: TextStyle(
        fontFamily: 'Quicksand Medium',
        fontSize: 12,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Quicksand Regular',
        fontSize: 12,
      ),
    ),

    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontFamily: 'Quicksand Bold',
        fontSize: 22,
        color: Colors.black,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Quicksand Semibold',
        fontSize: 16,
        color: Colors.black,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Quicksand Regular',
        fontSize: 14,
        color: Color(0xFF4B5563),
      ),
      bodySmall: TextStyle(
        fontFamily: 'Quicksand Light',
        fontSize: 12,
        color: Color(0xFF6B7280),
      ),
    ),
  );
}
