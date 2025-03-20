part of 'theme.dart';

final _lightTextTheme = TextTheme(
  labelSmall: _textStyle,
  labelMedium: _textStyle.copyWith(fontSize: 12.sp),
  labelLarge: _textStyle.copyWith(fontSize: 14.sp, letterSpacing: 0.1),
  bodySmall: _textStyle.copyWith(
    fontSize: 12.sp,
    letterSpacing: 0.4,
    fontWeight: regularFontWeight,
  ),
  bodyMedium: _textStyle.copyWith(
    fontSize: 14.sp,
    letterSpacing: 0.25,
    fontWeight: regularFontWeight,
  ),
  bodyLarge: _textStyle.copyWith(
    fontSize: 16.sp,
    letterSpacing: 0.5,
    fontWeight: regularFontWeight,
  ),
  titleSmall: _textStyle.copyWith(fontSize: 14.sp, letterSpacing: 0.1),
  titleMedium: _textStyle.copyWith(fontSize: 16.sp, letterSpacing: 0.15),
  titleLarge: _textStyle.copyWith(
    fontSize: 22.sp,
    fontWeight: regularFontWeight,
    letterSpacing: 0,
  ),
  headlineSmall: _textStyle.copyWith(
    fontSize: 24.sp,
    fontWeight: regularFontWeight,
    letterSpacing: 0,
  ),
  headlineMedium: _textStyle.copyWith(
    fontSize: 28.sp,
    fontWeight: regularFontWeight,
    letterSpacing: 0,
  ),
  headlineLarge: _textStyle.copyWith(
    fontSize: 32.sp,
    fontWeight: regularFontWeight,
    letterSpacing: 0,
  ),
  displaySmall: _textStyle.copyWith(
    fontSize: 36.sp,
    fontWeight: regularFontWeight,
    letterSpacing: 0,
  ),
  displayMedium: _textStyle.copyWith(
    fontSize: 45.sp,
    fontWeight: regularFontWeight,
    letterSpacing: 0,
  ),
  displayLarge: _textStyle.copyWith(
    fontSize: 57.sp,
    fontWeight: regularFontWeight,
    letterSpacing: -0.25,
  ),
);

final _darkTextTheme = TextTheme(
  labelSmall: _textStyle,
  labelMedium: _textStyle.copyWith(fontSize: 12.sp),
  labelLarge: _textStyle.copyWith(fontSize: 14.sp, letterSpacing: 0.1),
  bodySmall: _textStyle.copyWith(
    fontSize: 12.sp,
    letterSpacing: 0.4,
    fontWeight: regularFontWeight,
  ),
  bodyMedium: _textStyle.copyWith(
    fontSize: 14.sp,
    letterSpacing: 0.25,
    fontWeight: regularFontWeight,
  ),
  bodyLarge: _textStyle.copyWith(
    fontSize: 16.sp,
    letterSpacing: 0.5,
    fontWeight: regularFontWeight,
  ),
  titleSmall: _textStyle.copyWith(fontSize: 14.sp, letterSpacing: 0.1),
  titleMedium: _textStyle.copyWith(fontSize: 16.sp, letterSpacing: 0.15),
  titleLarge: _textStyle.copyWith(
    fontSize: 22.sp,
    fontWeight: regularFontWeight,
    letterSpacing: 0,
  ),
  headlineSmall: _textStyle.copyWith(
    fontSize: 24.sp,
    fontWeight: regularFontWeight,
    letterSpacing: 0,
  ),
  headlineMedium: _textStyle.copyWith(
    fontSize: 28.sp,
    fontWeight: regularFontWeight,
    letterSpacing: 0,
  ),
  headlineLarge: _textStyle.copyWith(
    fontSize: 32.sp,
    fontWeight: regularFontWeight,
    letterSpacing: 0,
  ),
  displaySmall: _textStyle.copyWith(
    fontSize: 36.sp,
    fontWeight: regularFontWeight,
    letterSpacing: 0,
  ),
  displayMedium: _textStyle.copyWith(
    fontSize: 45.sp,
    fontWeight: regularFontWeight,
    letterSpacing: 0,
  ),
  displayLarge: _textStyle.copyWith(
    fontSize: 57.sp,
    fontWeight: regularFontWeight,
    letterSpacing: -0.25,
  ),
);

final _textStyle = TextStyle(
  fontSize: 14.sp,
  letterSpacing: 0.5,
  fontWeight: mediumFontWeight,
);

/// Light font weight constant (300)
const lightFontWeight = FontWeight.w300;

/// Regular font weight constant (400)
const regularFontWeight = FontWeight.w400;

/// Medium font weight constant (500)
const mediumFontWeight = FontWeight.w500;

/// Semi-bold font weight constant (600)
const semiBoldFontWeight = FontWeight.w600;

/// Bold font weight constant (700)
const boldFontWeight = FontWeight.w700;
