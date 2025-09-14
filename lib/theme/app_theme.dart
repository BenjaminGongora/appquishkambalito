import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    final ThemeData base = ThemeData.dark();

    return base.copyWith(
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryBlue,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primaryBlue,
        secondary: AppColors.accentOrange,
        surface: AppColors.cardDark,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.white),
        titleTextStyle: TextStyle(
          color: AppColors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: base.textTheme.copyWith(
        displayLarge: base.textTheme.displayLarge?.copyWith(
          color: AppColors.white,
        ),
        displayMedium: base.textTheme.displayMedium?.copyWith(
          color: AppColors.white,
        ),
        displaySmall: base.textTheme.displaySmall?.copyWith(
          color: AppColors.white,
        ),
        headlineMedium: base.textTheme.headlineMedium?.copyWith(
          color: AppColors.white,
        ),
        headlineSmall: base.textTheme.headlineSmall?.copyWith(
          color: AppColors.white,
        ),
        titleLarge: base.textTheme.titleLarge?.copyWith(color: AppColors.white),
        titleMedium: base.textTheme.titleMedium?.copyWith(
          color: AppColors.white,
          fontSize: 16,
        ),
        titleSmall: base.textTheme.titleSmall?.copyWith(
          color: AppColors.greyText,
          fontSize: 14,
        ),
        bodyLarge: base.textTheme.bodyLarge?.copyWith(color: AppColors.white),
        bodyMedium: base.textTheme.bodyMedium?.copyWith(
          color: AppColors.greyText,
        ),
        bodySmall: base.textTheme.bodySmall?.copyWith(
          color: AppColors.greyText,
          fontSize: 12,
        ),
        labelLarge: base.textTheme.labelLarge?.copyWith(color: AppColors.white),
      ),
      cardTheme: base.cardTheme.copyWith(
        color: AppColors.cardDark,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      iconTheme: const IconThemeData(color: AppColors.greyText),
    );
  }
}
