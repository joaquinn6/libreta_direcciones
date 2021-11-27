import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

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
  dividerColor: const Color(0xFFB5EDB3),
  dialogBackgroundColor: const Color(0xE1FFFFFF),
  textTheme: GoogleFonts.rubikTextTheme(),
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    ),
  ),
  iconTheme: const IconThemeData(
    color: Colors.black,
  ),
);

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: const MaterialColor(
      0xFF3C6448,
      <int, Color>{
        50: Color(0x1A245D41),
        100: Color(0xA1245D3C),
        200: Color(0xAA245D42),
        300: Color(0xAF245D3E),
        400: Color(0x1A124833),
        500: Color(0xA1124841),
        600: Color(0xAA124648),
        700: Color(0xFF122548),
        800: Color(0xAF11062F),
        900: Color(0xFF0E062F)
      },
    ),
    canvasColor: Color.fromARGB(207, 16, 16, 17),
    dividerColor: const Color(0xEE578D80),
    dialogBackgroundColor: const Color(0xD0101011),
    bottomAppBarColor: const Color(0xFF3C6448),
    appBarTheme: const AppBarTheme(
      color: Color(0xFF3C6448),
      systemOverlayStyle: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    primaryColor: const Color(0xFF3C6448),
    textTheme: GoogleFonts.rubikTextTheme(
        ThemeData(brightness: Brightness.dark).textTheme),
    cardColor: const Color(0xE3101011));
