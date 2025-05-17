/// A string extension
extension StringExtension on String {
  /// Get the navigation path for the current string
  String get navPath => '/$this';

  /// Convert given string to capitalised
  String get toCapitalised => '${this[0].toUpperCase()}${substring(1)}';

  /// For get Formatted Song Title
  String get formatSongTitle {
    final replacementsForSongTitle = {'&amp;': '&', '&#039;': "'", '&quot;': '"'};
    final pattern = RegExp(replacementsForSongTitle.keys.map(RegExp.escape).join('|'));
    final finalTitle = replaceAllMapped(pattern, (match) => replacementsForSongTitle[match.group(0)] ?? '').trimLeft();
    return finalTitle;
  }
}
