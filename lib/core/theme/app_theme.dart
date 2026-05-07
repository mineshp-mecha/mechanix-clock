import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF151515);
  static const Color cardBackground = Color(0xFF2D2D2D);
  
  static const Color textPrimary = Color(0xFFDDDDDD);
  static const Color textSecondary = Color(0xFFADADAD);
  static const Color textGrey = Color(0xFF808080);
  static const Color textDim = Color(0xFF717171);
  static const Color textDark = Color(0xFF212121);
  static const Color textMuted = Color(0xFF636363);
  static const Color textLightGrey = Color(0xFFBDBDBD);
  static const Color textNormalGrey = Color(0xFF9E9E9E);
  static const Color textOffWhite = Color(0xFFEEEEEE);

  static const Color border = Color(0xFF2D2D2D);
  static const Color borderDark = Color(0xFF212121);
  
  static const Color accent = Color(0xFFDDDDDD);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.accent,
      fontFamily: 'Sora',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 60,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
          height: 1.2,
        ),
        displayMedium: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
          height: 1.2,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          height: 1.2,
          letterSpacing: -0.01,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: AppColors.textNormalGrey,
          height: 1.2,
        ),
        bodyLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w300,
          color: AppColors.textPrimary,
          height: 1.2,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w300,
          color: AppColors.textOffWhite,
          height: 1.2,
          letterSpacing: -0.03,
        ),
      ),
    );
  }
}
