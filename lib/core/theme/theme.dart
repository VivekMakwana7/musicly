import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'text_theme.dart';
part 'app_bar_theme.dart';

/// Light Theme
final lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  fontFamily: 'Urbanist',
  colorScheme: const ColorScheme.light(primary: AppColors.primary),
  scaffoldBackgroundColor: Colors.transparent,
  textTheme: _lightTextTheme,
  appBarTheme: _lightAppBarTheme,
  inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder(borderSide: BorderSide.none)),
);

/// Dark Theme
final darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  fontFamily: 'Urbanist',
  colorScheme: const ColorScheme.dark(primary: AppColors.primary),
  scaffoldBackgroundColor: Colors.transparent,
  textTheme: _darkTextTheme,
  appBarTheme: _darkAppBarTheme,
  inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder(borderSide: BorderSide.none)),
);

/// App Gradient
const Decoration appDecoration = BoxDecoration(
  gradient: LinearGradient(
    colors: [AppColors.primary, AppColors.background, AppColors.background, AppColors.background, AppColors.primary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ),
);

/// Bottom Sheet Decoration
const Decoration sheetDecoration = BoxDecoration(
  gradient: LinearGradient(
    colors: [AppColors.primary, AppColors.background, AppColors.background],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ),
);

/// Recent Played Item decorations
final Decoration recentPlayedItemDecoration = BoxDecoration(
  color: AppColors.surface,
  borderRadius: BorderRadius.circular(26.r),
  border: const Border(top: BorderSide(color: AppColors.borderTop, width: 0.5)),
  boxShadow: [
    const BoxShadow(color: AppColors.shadowDark, blurRadius: 30, offset: Offset(-7, -7)),
    BoxShadow(color: AppColors.shadowDarker.withValues(alpha: 0.75), blurRadius: 20, offset: const Offset(7, 7)),
  ],
);

/// Audio Widget Decoration
final Decoration audioWidgetDecoration = BoxDecoration(
  color: const Color(0xFF282C30),
  borderRadius: BorderRadius.circular(26.r),
  border: const Border(top: BorderSide(color: Color(0xFF424750), width: 0.5)),
  boxShadow: [
    BoxShadow(color: const Color(0xFF262E32).withValues(alpha: 0.7), blurRadius: 20, offset: const Offset(-3, -3)),
    BoxShadow(color: const Color(0xFF101012).withValues(alpha: 0.75), blurRadius: 20, offset: const Offset(4, 4)),
  ],
);

/// Music Seek Bar Decoration
final Decoration musicSeekBarDecoration = BoxDecoration(
  gradient: const LinearGradient(colors: [AppColors.accent1, AppColors.accent2]),
  borderRadius: BorderRadius.all(Radius.circular(6.r)),
);

/// Color constants used in the app
/// - [primary]: #353A40 - Main brand color (dark gray)
/// - [background]: #121212 - App background color (dark)
/// - [surface]: #1C1F22 - Surface/card color (slightly lighter dark)
/// - [accent1]: #016BB8 - Primary accent color (blue)
/// - [accent2]: #11A8FD - Secondary accent color (lighter blue)
/// - [borderTop]: #3B4047 - Border top color
/// - [shadowDark]: #262E32 - Dark shadow color
/// - [shadowDarker]: #101012 - Darker shadow color with alpha
/// - [audioGradientStart]: #2C3036 - Audio widget gradient start color
/// - [audioGradientEnd]: #31343C - Audio widget gradient end color
/// - [audioShadowLight]: #485057 - Audio widget light shadow color
class AppColors {
  const AppColors._();

  /// A class containing color constants used throughout the app.
  ///
  /// This class provides a centralized place to define and access
  /// the app's color scheme. All colors are defined as static constants
  /// to ensure consistency across the UI.
  ///
  /// The colors include:
  /// - [primary]: Main brand color (dark gray)
  static const primary = Color(0xFF353A40);

  /// - [background]: App background color (dark)
  static const background = Color(0xFF121212);

  /// - [surface]: Surface/card color (slightly lighter dark)
  static const surface = Color(0xFF1C1F22);

  /// - [accent1]: Primary accent color (blue)
  static const accent1 = Color(0xFF016BB8);

  /// - [accent2]: Secondary accent color (lighter blue)
  static const accent2 = Color(0xFF11A8FD);

  /// - [borderTop]: Border top color
  static const borderTop = Color(0xFF3B4047);

  /// - [shadowDark]: Dark shadow color
  static const shadowDark = Color(0xFF262E32);

  /// - [shadowDarker]: Darker shadow color with alpha
  static const shadowDarker = Color(0xFF101012);

  /// - [audioGradientStart]: Audio widget gradient start color
  static const audioGradientStart = Color(0xFF2C3036);

  /// - [audioGradientEnd]: Audio widget gradient end color
  static const audioGradientEnd = Color(0xFF31343C);

  /// - [audioShadowLight]: Audio widget light shadow color
  static const audioShadowLight = Color(0xFF485057);
}
