/// A string extension
extension StringExtension on String {
  /// Get the navigation path for the current string
  String get navPath => '/$this';

  /// Convert given string to capitalised
  String get toCapitalised => '${this[0].toUpperCase()}${substring(1)}';
}
