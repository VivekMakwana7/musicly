import 'package:flutter/foundation.dart' show immutable;

/// Endpoints for the API
@immutable
final class EndPoints {
  const EndPoints._();

  /// Endpoints for Global Search Songs/Albums/Artists
  static const String search = '/search';

  /// Endpoint for Search Song by given Id
  static const String searchSongById = '/songs';

  /// Endpoint for Search Album
  static const String searchAlbumById = '/albums';

  /// Endpoint for Search Artist By Given Id
  static const String searchArtistById = '/artists';

  /// Endpoint for search Playlist By Given Id
  static const String searchPlaylistById = '/playlists';

  /// Endpoint for Search Songs By Query
  static const String searchSongByQuery = '/search/songs';

  /// Endpoint for Search Albums By Query
  static const String searchAlbumByQuery = '/search/albums';

  /// Endpoint for Search Artists By Query
  static const String searchArtistByQuery = '/search/artists';

  /// Endpoint for Search Playlists By Query
  static const String searchPlaylistByQuery = '/search/playlists';
}
