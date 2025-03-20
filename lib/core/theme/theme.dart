import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'text_theme.dart';
part 'app_bar_theme.dart';

/// Light Theme
final lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  fontFamily: 'Urbanist',
  colorScheme: const ColorScheme.light(primary: Color(0xFF353A40)),
  scaffoldBackgroundColor: Colors.transparent,
  textTheme: _lightTextTheme,
  appBarTheme: _lightAppBarTheme,
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(borderSide: BorderSide.none),
  ),
);

/// Dark Theme
final darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  fontFamily: 'Urbanist',
  colorScheme: const ColorScheme.dark(primary: Color(0xFF353A40)),
  scaffoldBackgroundColor: Colors.transparent,
  textTheme: _darkTextTheme,
  appBarTheme: _darkAppBarTheme,
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(borderSide: BorderSide.none),
  ),
);
