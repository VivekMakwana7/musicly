part of 'theme.dart';

final _lightAppBarTheme = AppBarTheme(
  titleTextStyle: _lightTextTheme.titleMedium?.copyWith(
    fontWeight: semiBoldFontWeight,
  ),
  scrolledUnderElevation: 0,
  centerTitle: false,
  backgroundColor: Colors.transparent,
);

final _darkAppBarTheme = AppBarTheme(
  titleTextStyle: _darkTextTheme.titleMedium?.copyWith(
    fontWeight: semiBoldFontWeight,
  ),
  scrolledUnderElevation: 0,
  centerTitle: false,
  backgroundColor: Colors.transparent,
);
