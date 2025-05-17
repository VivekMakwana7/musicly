import 'dart:io';

import 'package:hive_ce/hive.dart';
import 'package:musicly/core/db/base_data_manager.dart';
import 'package:musicly/core/db/models/album/db_album_model.dart';
import 'package:musicly/core/db/models/artist/db_artist_model.dart';
import 'package:musicly/core/db/models/playlist/db_playlist_model.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';
import 'package:musicly/core/db/models/song_playlist/db_song_playlist_model.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/logger.dart';

/// This class represents the application's local database using Hive.
base class AppDB {
  AppDB._(this._box);

  static const _appDbBox = '_appDbBox';

  /// The Hive box instance for storing data.
  final Box<dynamic> _box;

  /// Retrieves an instance of [AppDB].
  ///
  /// This method initializes the Hive box and returns an [AppDB] instance.
  /// If an error occurs during box opening, it attempts to delete the app's
  /// document directory and retry opening the box.  This is to handle potential
  /// database corruption scenarios.
  static Future<AppDB> getInstance() async {
    await Injector.instance.isReady<Directory>(instanceName: appDocDirInstanceName);
    try {
      final box = await Hive.openBox<dynamic>(_appDbBox);
      _initialise(box);
      return AppDB._(box);
    } on Object catch (e) {
      'Error opening AppDB: $e. Attempting to reset database.'.logE;
      final appDir = Injector.instance<Directory>(instanceName: appDocDirInstanceName);
      if (appDir.existsSync()) {
        appDir.deleteSync(recursive: true);
      }
      // Retry opening the box after resetting the database.
      final box = await Hive.openBox<dynamic>(_appDbBox);
      _initialise(box);
      return AppDB._(box);
    }
  }

  /// Logs out the current user by clearing all data from the local database.
  ///
  /// This method attempts to clear the Hive box, removing all stored data.
  /// If an error occurs during the process, it logs an error message and
  /// throws an exception to indicate that the logout operation failed.
  ///
  /// Throws an [Exception] if clearing the box fails.
  Future<void> logoutUser() async {
    try {
      await _box.clear();
    } on Object catch (e) {
      'Error in logoutUser $e'.logE;
      throw Exception('Error in logoutUser');
    }
  }

  /// The [SearchManager] instance for managing search history.
  static late final SearchManager searchManager;

  /// The [LikedManager] instance for managing liked content.
  static late final LikedManager likedManager;

  /// The [DownloadManager] instance for managing downloaded content.
  static late final DownloadManager downloadManager;

  /// The [SettingManager] instance for managing application settings.
  static late final SettingManager settingManager;

  /// The [HomeManager] instance for managing home screen data.
  static late final HomeManager homeManager;

  /// The [PlaylistManager] instance for managing playlists.
  static late final PlaylistManager playlistManager;

  /// Initializes the manager instances.

  static void _initialise(Box<dynamic> box) {
    searchManager = SearchManager(box);
    likedManager = LikedManager(box);
    downloadManager = DownloadManager(box);
    settingManager = SettingManager(box);
    homeManager = HomeManager(box);
    playlistManager = PlaylistManager(box);
  }
}

/// Manages the search history for different content types (songs, albums, artists, playlists).
///
/// This class extends [BaseDataManager] and provides methods to access, modify,
/// and stream updates to the search history for various content types.
class SearchManager extends BaseDataManager {
  /// Creates a [SearchManager] instance.
  ///
  /// This constructor initializes the [SearchManager] with a specific Hive box.
  /// The box is used to store and retrieve search history data.
  ///
  /// [_box] is the Hive box instance used for data persistence. It should be an
  /// opened Hive box with the appropriate configuration for storing search data.
  SearchManager(super._box);

  static const _searchedSong = 'searchedSong';
  static const _searchedAlbum = 'searchedAlbum';
  static const _searchedArtist = 'searchedArtist';
  static const _searchedPlaylist = 'searchedPlaylist';

  /// Retrieves the list of searched songs.
  List<DbSongModel> get searchedSongs {
    final historyList = getValue(_searchedSong, defaultValue: <dynamic>[]);
    return historyList.map((e) => e as DbSongModel).toList();
  }

  set searchedSongs(List<DbSongModel> history) {
    setValue(_searchedSong, history);
  }

  /// Provides a stream of updates for the song search history.
  Stream<BoxEvent> searchedSongStream() {
    return getStream(_searchedSong);
  }

  /// Retrieves the list of searched albums.
  List<DbAlbumModel> get searchedAlbums {
    final historyList = getValue(_searchedAlbum, defaultValue: <dynamic>[]);
    return historyList.map((e) => e as DbAlbumModel).toList();
  }

  set searchedAlbums(List<DbAlbumModel> history) {
    setValue(_searchedAlbum, history);
  }

  /// Provides a stream of updates for the album search history.
  Stream<BoxEvent> searchedAlbumStream() => getStream(_searchedAlbum);

  /// Retrieves the list of searched artists.
  List<DbArtistModel> get searchedArtists {
    final historyList = getValue(_searchedArtist, defaultValue: <dynamic>[]);
    return historyList.map((e) => e as DbArtistModel).toList();
  }

  set searchedArtists(List<DbArtistModel> history) {
    setValue(_searchedArtist, history);
  }

  /// Provides a stream of updates for the artist search history.
  Stream<BoxEvent> searchedArtistStream() => getStream(_searchedArtist);

  /// Retrieves the list of searched playlists.
  List<DbPlaylistModel> get searchedPlaylists {
    final historyList = getValue(_searchedPlaylist, defaultValue: <dynamic>[]);
    return historyList.map((e) => e as DbPlaylistModel).toList();
  }

  set searchedPlaylists(List<DbPlaylistModel> history) {
    setValue(_searchedPlaylist, history);
  }

  /// Provides a stream of updates for the playlist search history.
  Stream<BoxEvent> searchedPlaylistStream() => getStream(_searchedPlaylist);

  /// Checks if any search history exists for any of the content types.
  bool get isSearchedEmpty =>
      searchedSongs.isEmpty && searchedAlbums.isEmpty && searchedArtists.isEmpty && searchedPlaylists.isEmpty;

  /// Provides a stream of updates for the specified content type.
  Stream<BoxEvent> searchedStream<T>() {
    if (T == DbSongModel) return searchedSongStream();
    if (T == DbAlbumModel) return searchedAlbumStream();
    if (T == DbArtistModel) return searchedArtistStream();
    if (T == DbPlaylistModel) return searchedPlaylistStream();
    throw UnimplementedError('Unsupported type: $T');
  }
}

/// Manages the user's liked content (songs, albums, playlists).
///
/// This class extends [BaseDataManager] and provides methods to access, modify,
/// and stream updates to the user's liked content. It also includes a method
/// to check if any liked content exists.
class LikedManager extends BaseDataManager {
  /// Creates a [LikedManager] instance.
  LikedManager(super._box);

  static const _likedSong = 'likedSongs';
  static const _likedAlbum = 'likedAlbums';
  static const _likedPlaylist = 'likedPlaylists';

  /// For get Liked Songs
  List<DbSongModel> get likedSongs {
    final historyList = getValue(_likedSong, defaultValue: <dynamic>[]);
    return historyList.map((e) => e as DbSongModel).toList();
  }

  /// For set Liked Songs
  set likedSongs(List<DbSongModel> history) {
    setValue(_likedSong, history);
  }

  /// Stream for Liked Song Stream
  Stream<BoxEvent> likedSongStream() {
    return getStream(_likedSong);
  }

  /// For get Liked Albums
  List<DbAlbumModel> get likedAlbums {
    final historyList = getValue(_likedAlbum, defaultValue: <dynamic>[]);
    return historyList.map((e) => e as DbAlbumModel).toList();
  }

  /// For set Liked Albums
  set likedAlbums(List<DbAlbumModel> history) {
    setValue(_likedAlbum, history);
  }

  /// Stream for Liked Album Stream
  Stream<BoxEvent> likedAlbumStream() {
    return getStream(_likedAlbum);
  }

  /// For get Liked Playlists
  List<DbPlaylistModel> get likedPlaylists {
    final historyList = getValue(_likedPlaylist, defaultValue: <dynamic>[]);
    return historyList.map((e) => e as DbPlaylistModel).toList();
  }

  /// For set Liked Playlists
  set likedPlaylists(List<DbPlaylistModel> history) {
    setValue(_likedPlaylist, history);
  }

  /// Stream for Liked Playlist Stream
  Stream<BoxEvent> likedPlaylistStream() {
    return getStream(_likedPlaylist);
  }

  /// For check all liked song, Album or Playlist are empty then liked is empty
  bool get isLikedEmpty => likedSongs.isEmpty && likedAlbums.isEmpty && likedPlaylists.isEmpty;

  /// Provides a stream of updates for the specified content type.
  Stream<BoxEvent> likedStream<T>() {
    if (T == DbSongModel) {
      return likedSongStream();
    } else if (T == DbAlbumModel) {
      return likedAlbumStream();
    } else if (T == DbPlaylistModel) {
      return likedPlaylistStream();
    } else {
      throw UnimplementedError('Unsupported type: $T');
    }
  }
}

/// Manages the downloaded songs.
///
/// This class extends [BaseDataManager] and provides methods to access, modify,
/// and stream updates to the list of downloaded songs. It also includes a method
/// to check if any songs are downloaded.
class DownloadManager extends BaseDataManager {
  /// Creates a [DownloadManager] instance.
  DownloadManager(super._box);

  static const _downloadedSongs = 'downloadedSongs';

  /// Retrieves the list of downloaded songs.
  List<DbSongModel> get downloadedSongs {
    final historyList = getValue(_downloadedSongs, defaultValue: <dynamic>[]);
    return historyList.map((e) => e as DbSongModel).toList();
  }

  set downloadedSongs(List<DbSongModel> songs) {
    setValue(_downloadedSongs, songs);
  }

  /// Provides a stream of updates for the downloaded songs.
  Stream<BoxEvent> downloadedSongStream() {
    return getStream(_downloadedSongs);
  }

  /// Checks if any songs are downloaded.
  bool get isEmpty => downloadedSongs.isEmpty;

  /// Provides a stream of updates for the specified content type.
  Stream<BoxEvent> downloadedStream<T>() {
    if (T == DbSongModel) {
      return downloadedSongStream();
    } else {
      throw UnimplementedError('Unsupported type: $T');
    }
  }
}

/// Manages application settings, such as song quality and gapLess playback.
///
/// This class extends [BaseDataManager] and provides methods to access and modify these settings.
class SettingManager extends BaseDataManager {
  /// Creates a [SettingManager] instance.
  SettingManager(super._box);

  static const _songQuality = 'songQuality';
  static const _gapLess = 'gapLess';

  /// For  get Song Quality
  String? get songQuality {
    return getValue(_songQuality);
  }

  /// For set Song Quality
  set songQuality(String? quality) {
    setValue(_songQuality, quality);
  }

  /// For set Song GapLess
  bool get gapLess {
    return getValue(_gapLess, defaultValue: false);
  }

  set gapLess(bool? value) {
    setValue(_gapLess, value);
  }
}

/// Manages data related to the home screen, such as recently played songs.
///
/// This class extends [BaseDataManager] and provides methods to access, modify,
/// and stream updates to the list of recently played songs. It also includes a
/// method to check if any recently played songs exist.
class HomeManager extends BaseDataManager {
  /// Creates a [HomeManager] instance.
  HomeManager(super._box);

  static const _recentPlayedSongs = 'recentPlayedSong';

  /// For get Recent Played Songs
  List<DbSongModel> get recentPlayedSongs {
    final historyList = getValue(_recentPlayedSongs, defaultValue: <dynamic>[]);
    return historyList.map((e) => e as DbSongModel).toList();
  }

  /// For set Recent Played Songs
  set recentPlayedSongs(List<DbSongModel> history) {
    setValue(_recentPlayedSongs, history);
  }

  /// Stream for Recent Played Song Stream
  Stream<BoxEvent> recentPlayedSongStream() {
    return getStream(_recentPlayedSongs);
  }

  /// For check Home Empty or Not
  bool get isEmpty => recentPlayedSongs.isEmpty;

  /// Provides a stream of updates for the specified content type.
  Stream<BoxEvent> homeStream<T>() {
    if (T == DbSongModel) {
      return recentPlayedSongStream();
    } else {
      throw UnimplementedError('Unsupported type: $T');
    }
  }
}

/// Manages user-created playlists.
///
/// This class extends [BaseDataManager] and provides methods to access, modify,
/// and stream updates to the list of user-created playlists. It also includes a
/// method to check if any playlists exist.
class PlaylistManager extends BaseDataManager {
  /// Creates a [PlaylistManager] instance.
  PlaylistManager(super._box);

  static const _songPlaylist = 'songPlaylist';

  /// For get Song Playlist
  List<DbSongPlaylistModel> get songPlaylist {
    final list = getValue(_songPlaylist, defaultValue: <dynamic>[]);
    return list.map((e) => e as DbSongPlaylistModel).toList();
  }

  /// For set Song Playlist
  set songPlaylist(List<DbSongPlaylistModel> list) {
    setValue(_songPlaylist, list);
  }

  /// Stream for Song Playlist Stream
  Stream<BoxEvent> songPlaylistStream() {
    return getStream(_songPlaylist);
  }

  /// Provides a stream of updates for the specified content type.
  Stream<BoxEvent> playlistStream<T>() {
    if (T == DbSongPlaylistModel) {
      return songPlaylistStream();
    } else {
      throw UnimplementedError('Unsupported type: $T');
    }
  }

  /// Checks if any playlists exist.
  bool get isEmpty => songPlaylist.isEmpty;
}
