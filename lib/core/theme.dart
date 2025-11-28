import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Color(0xFF141821),
    primaryColor: Color(0xFF00F5D4),
    fontFamily: 'Inter',
    textTheme: TextTheme(
      displayLarge: TextStyle(fontSize: 28, color: Colors.white),
       bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
    ),

  );
}
