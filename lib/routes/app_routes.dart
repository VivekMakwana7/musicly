part of 'app_router.dart';

/// A utility class that defines the application's routing constants.
/// This class cannot be instantiated as it only contains static members.
final class AppRoutes {
  /// Private constructor to prevent instantiation of this utility class
  AppRoutes._();

  /// The initial route path of the application.
  /// This constant represents the starting point of the app's navigation,
  /// typically pointing to the home or splash screen.
  static const String initialLocation = '/$homePage';

  /// The route path for the home screen.
  static const String homePage = 'home-page';

  /// The route path for the search screen.
  static const String searchPage = 'search-page';

  /// The route path for the library screen.
  static const String libraryPage = 'library-page';

  /// The route path for the liked screen.
  static const String likedPage = 'liked-page';

  /// The route path for the search song screen.
  static const String searchSongPage = 'search-song-page';

  /// The route path for the search album screen
  static const String searchAlbumPage = 'search-album-page';

  /// The route path for the search artist screen
  static const String searchArtistPage = 'search-artist-page';

  /// The route path for the search playlist screen
  static const String searchPlaylistPage = 'search-playlist-page';
}
