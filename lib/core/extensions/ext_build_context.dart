import 'package:flutter/material.dart';

/// extension for [BuildContext]
extension BuildContextEx on BuildContext {
  /// to get theme
  ThemeData get theme => Theme.of(this);

  /// to get colorScheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// to get text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// to get size of screen
  Size get sizeOf => MediaQuery.sizeOf(this);

  /// to get width from media query
  double get width => sizeOf.width;

  /// to get height from media query
  double get height => sizeOf.height;

  /// to get device pixel ratio
  double get pixelRatio => MediaQuery.of(this).devicePixelRatio;

  /// to get width in pixels
  double get widthPixel => width * pixelRatio;

  /// to get height in pixels
  double get heightPixel => height * pixelRatio;

  /// to get view insets
  EdgeInsets get viewInsetsOf => MediaQuery.viewInsetsOf(this);

  /// to theme brightness [Brightness.dark] or [Brightness.light]
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// to get view Padding of the display that are partially obscured by system UI
  EdgeInsets get viewPaddingOf => MediaQuery.viewPaddingOf(this);
}
