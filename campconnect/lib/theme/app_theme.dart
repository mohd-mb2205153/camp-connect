import 'package:flutter/material.dart';
import 'styling_constants.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.white,
    primaryColor: AppColors.teal,
    primaryColorDark: AppColors.darkTeal,
    primaryColorLight: AppColors.beige,
    dialogBackgroundColor: AppColors.darkBlue,
    colorScheme: ColorScheme.light(
      primary: AppColors.teal,
      secondary: AppColors.blue,
    ),
    textTheme: TextTheme(
      bodySmall: TextStyle(
          fontFamily: 'DMSans', fontSize: 14, fontWeight: FontWeight.normal),
      bodyMedium: TextStyle(
          fontFamily: 'DMSans', fontSize: 18, fontWeight: FontWeight.normal),
      bodyLarge: TextStyle(
          fontFamily: 'DMSans', fontSize: 22, fontWeight: FontWeight.normal),
      headlineSmall: TextStyle(
          fontFamily: 'DMSans', fontSize: 28, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(
          fontFamily: 'DMSans', fontSize: 36, fontWeight: FontWeight.bold),
    ),
  );

  // You can define a dark theme here if needed
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkTeal,
    primaryColor: AppColors.darkBlue,
    colorScheme: ColorScheme.dark(
      primary: AppColors.darkBlue,
      secondary: AppColors.grey,
    ),
    textTheme: TextTheme(
      bodySmall: TextStyle(
          fontFamily: 'DMSans', fontSize: 14, fontWeight: FontWeight.normal),
      bodyMedium: TextStyle(
          fontFamily: 'DMSans', fontSize: 18, fontWeight: FontWeight.normal),
      bodyLarge: TextStyle(
          fontFamily: 'DMSans', fontSize: 22, fontWeight: FontWeight.normal),
      headlineSmall: TextStyle(
          fontFamily: 'DMSans', fontSize: 28, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(
          fontFamily: 'DMSans', fontSize: 36, fontWeight: FontWeight.bold),
    ),
  );
}
