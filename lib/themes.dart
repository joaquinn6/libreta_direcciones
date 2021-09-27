import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: const MaterialColor(
    0xFFB5EDB3,
    <int, Color>{
      50: Color(0x1aF5E0C3),
      100: Color(0xA1CFF5C3),
      200: Color(0xAAC3F5E4),
      300: Color(0xAFC9F5C3),
      400: Color(0xFFC5F8C9),
      500: Color(0xFFB5EDB3),
      600: Color(0xFF9BDEA1),
      700: Color(0xFF7CC9C5),
      800: Color(0xFF5EA8B2),
      900: Color(0xFF3E938F)
    },
  ),
  canvasColor: const Color(0xFFFFFFFF),
  dividerColor: const Color(0x1F559DE0),
  dialogBackgroundColor: const Color(0xF1FFFFFF),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: const MaterialColor(
    0xFF3C6448,
    <int, Color>{
      50: Color(0x1a5D4524),
      100: Color(0xa15D4524),
      200: Color(0xaa5D4524),
      300: Color(0xaf5D4524),
      400: Color(0x1a483112),
      500: Color(0xa1483112),
      600: Color(0xaa483112),
      700: Color(0xff483112),
      800: Color(0xaf2F1E06),
      900: Color(0xff2F1E06)
    },
  ),
  canvasColor: const Color(0x34101011),
  dividerColor: const Color(0xEE578D80),
  dialogBackgroundColor: const Color(0xD0101011),
);
