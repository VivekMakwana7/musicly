import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/db/models/album/db_album_model.dart';
import 'package:musicly/core/db/models/artist/db_artist_model.dart';
import 'package:musicly/core/db/models/playlist/db_playlist_model.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/extensions/ext_string_alert.dart';
import 'package:musicly/core/logger.dart';
import 'package:musicly/core/rest_utils/api_request.dart';
import 'package:musicly/repos/search_repository.dart';

/// For handle Database related operations
class DatabaseHandler {
  /// Adds original details to the database based on the provided [id] and [type].
  static void appendToDb({required String id, required String type}) {
    switch (type) {
      case 'artist':
        _getArtistById(id);
      case 'album':
        _getAlbumById(id);
      case 'playlist':
        _getPlaylistById(id);
      case _:
        _getSongById(id);
    }
  }

  static Future<void> _getSongById(String songId) async {
    final searchRepo = Injector.instance<SearchRepository>();
    'Searching song by id : $songId'.logD;
    final res = await searchRepo.searchSongById(ApiRequest(pathParameter: songId));

    res.when(
      success: (data) {
        if (data.isNotEmpty) {
          'Song added to database : ${data.first.id}'.logD;
          addToSongSearchHistory(data.first);
        } else {
          'No data found '.logD;
        }
      },
      error: (exception) {
        'Search song by Id API failed : $exception'.logE;
        'Failed to add song to local database'.showErrorAlert();
      },
    );
  }

  /// Adds a song to the song search history in the database.
  static void addToSongSearchHistory(DbSongModel song) {
    final appDb = Injector.instance<AppDB>();
    // Check if the song already exists in history
    if (appDb.songSearchHistory.any((s) => s.id == song.id)) {
      'Song with ID ${song.id} is already in the search history.'.logD;
      return;
    }
    appDb.songSearchHistory = [song, ...appDb.songSearchHistory];
    'Song added to database : ${song.id}'.logD;
  }

  static Future<void> _getAlbumById(String albumId) async {
    final searchRepo = Injector.instance<SearchRepository>();
    'Searching Album by id : $albumId'.logD;
    final res = await searchRepo.searchAlbumById(ApiRequest(params: {'id': albumId}));

    res.when(
      success: addToAlbumSearchHistory,
      error: (exception) {
        'Search album by Id API failed : $exception'.logE;
        'Failed to add album to local database'.showErrorAlert();
      },
    );
  }

  /// Adds a album to the album search history in the database.
  static void addToAlbumSearchHistory(DbAlbumModel album) {
    final appDb = Injector.instance<AppDB>();
    // Check if the album already exists in history
    if (appDb.albumSearchHistory.any((s) => s.id == album.id)) {
      'Album with ID ${album.id} is already in the search history.'.logD;
      return;
    }
    appDb.albumSearchHistory = [album, ...appDb.albumSearchHistory];
    'Album added to database : ${album.id}'.logD;
  }

  static Future<void> _getArtistById(String artistId) async {
    final searchRepo = Injector.instance<SearchRepository>();
    'Searching Artist by id : $artistId'.logD;
    final res = await searchRepo.searchArtistById(ApiRequest(pathParameter: artistId));

    res.when(
      success: addToArtistSearchHistory,
      error: (exception) {
        'Search Artist by Id API failed : $exception'.logE;
        'Failed to add artist to local database'.showErrorAlert();
      },
    );
  }

  /// Adds a artist to the artist search history in the database.
  static void addToArtistSearchHistory(DbArtistModel artist) {
    final appDb = Injector.instance<AppDB>();
    // Check if the artist already exists in history
    if (appDb.artistSearchHistory.any((s) => s.id == artist.id)) {
      'Artist with ID ${artist.id} is already in the search history.'.logD;
      return;
    }
    appDb.artistSearchHistory = [artist, ...appDb.artistSearchHistory];
    'Artist added to database : ${artist.id}'.logD;
  }

  static Future<void> _getPlaylistById(String playlistId) async {
    final searchRepo = Injector.instance<SearchRepository>();
    'Searching Playlist by id : $playlistId'.logD;
    final res = await searchRepo.searchPlaylistById(ApiRequest(params: {'id': playlistId}));

    res.when(
      success: addToPlaylistSearchHistory,
      error: (exception) {
        'Search playlist by Id API failed : $exception'.logE;
        'Failed to add playlist to local database'.showErrorAlert();
      },
    );
  }

  /// Adds a playlist to the playlist search history in the database.
  static void addToPlaylistSearchHistory(DbPlaylistModel playlist) {
    final appDb = Injector.instance<AppDB>();
    // Check if the playlist already exists in history
    if (appDb.playlistSearchHistory.any((s) => s.id == playlist.id)) {
      'Playlist with ID ${playlist.id} is already in the search history.'.logD;
      return;
    }
    appDb.playlistSearchHistory = [playlist, ...appDb.playlistSearchHistory];
    'Playlist added to database : ${playlist.id}'.logD;
  }

  /// Handle Toggle liked Song
  static void toggleLikedSong(DbSongModel song) {
    final appDb = Injector.instance<AppDB>();
    if (appDb.likedSongs.any((s) => s.id == song.id)) {
      appDb.likedSongs.remove(song);
    } else {
      appDb.likedSongs.add(song);
    }
  }
}
