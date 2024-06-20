import 'package:flutter/material.dart';

class AppTheme {
  static final Color primaryColorLight = Color(0xFFF5F5F5);
  static final Color primaryColorDark = Color(0xFF0D1B2A);
  static final Color accentColorLight = Color(0xFF1E1E1E);
  static final Color accentColorDark = Color(0xFF6CCFF6);
  static final Color textColorLight = Colors.black;
  static final Color textColorDark = Colors.white;
  static final Color buttonColorLight = Colors.black;
  static final Color buttonColorDark = Colors.white;
  static final Color iconColorLight = Colors.black54;
  static final Color iconColorDark = Colors.white70;
  static final Color fillColorLight = Colors.white;
  static final Color fillColorDark = Color(0xFF1E1E1E);

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: primaryColorLight,
      secondary: accentColorLight,
      background: primaryColorLight,
      surface: fillColorLight,
      onPrimary: textColorLight,
      onSecondary: textColorLight,
      onBackground: textColorLight,
      onSurface: textColorLight,
      onError: Colors.red,
      error: Colors.red,
    ),
    scaffoldBackgroundColor: primaryColorLight,
    textTheme: TextTheme(
      bodyText1: TextStyle(color: textColorLight),
      bodyText2: TextStyle(color: textColorLight),
      headline6: TextStyle(color: accentColorLight),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: iconColorLight),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: accentColorLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: accentColorLight),
      ),
      fillColor: fillColorLight,
      filled: true,
    ),
    iconTheme: IconThemeData(color: iconColorLight),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: primaryColorDark,
      secondary: accentColorDark,
      background: primaryColorDark,
      surface: fillColorDark,
      onPrimary: textColorDark,
      onSecondary: textColorDark,
      onBackground: textColorDark,
      onSurface: textColorDark,
      onError: Colors.red,
      error: Colors.red,
    ),
    scaffoldBackgroundColor: primaryColorDark,
    textTheme: TextTheme(
      bodyText1: TextStyle(color: textColorDark),
      bodyText2: TextStyle(color: textColorDark),
      headline6: TextStyle(color: accentColorDark),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: iconColorDark),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: accentColorDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: accentColorDark),
      ),
      fillColor: fillColorDark,
      filled: true,
    ),
    iconTheme: IconThemeData(color: iconColorDark),
  );
}
