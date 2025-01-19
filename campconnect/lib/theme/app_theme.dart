import 'package:campconnect/theme/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
      backgroundColor: AppColors.white, // AppBar background color
      iconTheme: IconThemeData(color: AppColors.teal), // Icon color
      titleTextStyle: TextStyle(
        fontFamily: 'DMSans',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.teal,
      ),
    ),
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.white,
    primaryColor: AppColors.teal,
    primaryColorDark: AppColors.darkTeal,
    primaryColorLight: AppColors.lightTeal,
    dialogBackgroundColor: AppColors.darkBlue,
    colorScheme: ColorScheme.light(
      primary: AppColors.teal,
      secondary: AppColors.blue,
    ),
    textTheme: TextTheme(
      bodySmall: TextStyle(
        fontFamily: 'DMSans',
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'DMSans',
        fontSize: 18,
        fontWeight: FontWeight.normal,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'DMSans',
        fontSize: 22,
        fontWeight: FontWeight.normal,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'DMSans',
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'DMSans',
        fontSize: 36,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light, // For iOS: light icons
        statusBarIconBrightness:
            Brightness.light, // For Android (M and greater): light icons
      ),
      backgroundColor:
          AppColors.darkBlue, // AppBar background color for dark theme
      iconTheme: IconThemeData(color: AppColors.grey), // Icon color
      titleTextStyle: TextStyle(
        fontFamily: 'DMSans',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.grey,
      ),
    ),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkTeal,
    primaryColor: AppColors.darkBlue,
    colorScheme: ColorScheme.dark(
      primary: AppColors.darkBlue,
      secondary: AppColors.grey,
    ),
    textTheme: TextTheme(
      bodySmall: TextStyle(
        fontFamily: 'DMSans',
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'DMSans',
        fontSize: 18,
        fontWeight: FontWeight.normal,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'DMSans',
        fontSize: 22,
        fontWeight: FontWeight.normal,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'DMSans',
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'DMSans',
        fontSize: 36,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
