// import 'package:flutter/material.dart';

// ThemeData lightMode = ThemeData(
//     colorScheme: const ColorScheme.light(
//   primary: Colors.white,
//   secondary: Color.fromARGB(255, 49, 41, 41),
//   tertiary: Color(0xFf169839),
//   inversePrimary: Color.fromARGB(255, 134, 178, 207),
//   primaryFixed: Colors.white,
// ));
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const COLOR_PRIMARY = Colors.white;
const COLOR_BLACK = Colors.black;
const MY_THEME = Color(0xFf169839);

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: COLOR_PRIMARY,
    secondaryHeaderColor: COLOR_BLACK,
    colorScheme: const ColorScheme.light(
      primary: Colors.white,
      secondary: Color.fromARGB(255, 49, 41, 41),
      tertiary: Color(0xFf169839),
      inversePrimary: Color.fromARGB(255, 134, 178, 207),
    ),
    textTheme: TextTheme(
        titleLarge: GoogleFonts.sen(
            textStyle: const TextStyle(
                color: Color.fromARGB(255, 9, 0, 0), fontSize: 16))),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: COLOR_PRIMARY),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0)),
            shape: WidgetStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0))),
            backgroundColor: WidgetStateProperty.all<Color>(MY_THEME))),
    inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide.none),
        filled: true,
        fillColor: Colors.grey.withOpacity(0.1)));

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: COLOR_BLACK,
  secondaryHeaderColor: COLOR_PRIMARY,
  switchTheme: SwitchThemeData(
    trackColor: WidgetStateProperty.all<Color>(Colors.grey),
    thumbColor: WidgetStateProperty.all<Color>(Colors.white),
  ),
  inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide.none),
      filled: true,
      fillColor: Colors.grey.withOpacity(0.1)),
  textTheme: TextTheme(
      titleLarge: GoogleFonts.sen(
          textStyle: const TextStyle(
              color: Color.fromARGB(255, 9, 0, 0), fontSize: 18))),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(horizontal: 100.0, vertical: 20.0)),
          shape: WidgetStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0))),
          backgroundColor: WidgetStateProperty.all<Color>(COLOR_PRIMARY),
          foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
          overlayColor: WidgetStateProperty.all<Color>(Colors.black26))),
);
