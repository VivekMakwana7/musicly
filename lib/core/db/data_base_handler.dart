import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/db/models/album/db_album_model.dart';
import 'package:musicly/core/db/models/artist/db_artist_model.dart';
import 'package:musicly/core/db/models/playlist/db_playlist_model.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/extensions/ext_string_alert.dart';
import 'package:musicly/core/logger.dart';
import 'package:musicly/core/rest_utils/api_request.dart';
import 'package:musicly/repos/music_repo.dart';

/// Provides methods for handling database operations such as adding search history
/// and managing liked songs.
class DatabaseHandler {
  static final _searchManager = AppDB.searchManager;
  static final _likeManager = AppDB.likedManager;
  static final _downloadManager = AppDB.downloadManager;

  ///
  static Future<DbSongModel?> getSongById(String songId) async {
    final searchRepo = Injector.instance<MusicRepo>();
    DbSongModel? song;
    'Searching song by id : $songId'.logD;
    final res = await searchRepo.searchSongById(ApiRequest(pathParameter: songId));

    res.when(
      success: (data) {
        if (data.isNotEmpty) {
          song = data.first;
        } else {
          'No data found '.logD;
        }
      },
      error: (exception) {
        'Search song by Id API failed : $exception'.logE;
        'Failed to add song to local database'.showErrorAlert();
      },
    );

    return song;
  }

  /// Adds a song to the song search history in the database.
  static void addToSongSearchHistory(DbSongModel song) {
    // Check if the song already exists in history
    if (_searchManager.searchedSongs.any((s) => s.id == song.id)) {
      'Song with ID ${song.id} is already in the search history.'.logD;
      return;
    }
    _searchManager.searchedSongs = [song, ..._searchManager.searchedSongs];
    'Song added to database : ${song.id}'.logD;
  }

  /// Adds a album to the album search history in the database.
  static void addToAlbumSearchHistory(DbAlbumModel album) {
    // Check if the album already exists in history
    if (_searchManager.searchedAlbums.any((s) => s.id == album.id)) {
      'Album with ID ${album.id} is already in the search history.'.logD;
      return;
    }
    _searchManager.searchedAlbums = [album, ..._searchManager.searchedAlbums];
    'Album added to database : ${album.id}'.logD;
  }

  /// Adds a artist to the artist search history in the database.
  static void addToArtistSearchHistory(DbArtistModel artist) {
    // Check if the artist already exists in history
    if (_searchManager.searchedArtists.any((s) => s.id == artist.id)) {
      'Artist with ID ${artist.id} is already in the search history.'.logD;
      return;
    }
    _searchManager.searchedArtists = [artist, ..._searchManager.searchedArtists];
    'Artist added to database : ${artist.id}'.logD;
  }

  /// Adds a playlist to the playlist search history in the database.
  static void addToPlaylistSearchHistory(DbPlaylistModel playlist) {
    // Check if the playlist already exists in history
    if (_searchManager.searchedPlaylists.any((s) => s.id == playlist.id)) {
      'Playlist with ID ${playlist.id} is already in the search history.'.logD;
      return;
    }
    _searchManager.searchedPlaylists = [playlist, ..._searchManager.searchedPlaylists];
    'Playlist added to database : ${playlist.id}'.logD;
  }

  /// Toggles the like status of a song in the database.
  /// [song] The song to toggle.
  /// [showToast] Whether to show a success/failure toast message.
  static void toggleLikedSong(DbSongModel song, {bool showToast = false}) {
    final list = _likeManager.likedSongs.toList();
    if (list.any((s) => s.id == song.id)) {
      list.removeWhere((element) => element.id == song.id);
      if (showToast) 'Song removed from liked songs'.showSuccessAlert();
    } else {
      list.insert(0, song);
      if (showToast) 'Song added to liked songs'.showSuccessAlert();
    }

    _likeManager.likedSongs = list;
  }

  /// Checks if a song is liked in the local database.
  static bool isSongLiked(DbSongModel song) {
    final list = _likeManager.likedSongs;
    return list.any((s) => s.id == song.id);
  }

  /// Adds a song to the downloaded songs in the database.
  static void addToDownloadedSongs(DbSongModel song) {
    final list = _downloadManager.downloadedSongs.toList();
    if (list.any((s) => s.id == song.id)) {
      // Show Error Alert
      'Song already downloaded'.showErrorAlert();
      return;
    } else {
      list.insert(0, song);
      'Song added to downloaded songs'.logD;
    }
    _downloadManager.downloadedSongs = list;
  }

  /// Checks if a song is downloaded in the local database.
  static bool isDownloaded(DbSongModel song) {
    final list = _downloadManager.downloadedSongs.toList();
    return list.any((s) => s.id == song.id);
  }

  /// Toggles the like status of a album in the database.
  static void toggleLikedAlbum(DbAlbumModel album) {
    final list = _likeManager.likedAlbums.toList();
    if (list.any((s) => s.id == album.id)) {
      list.removeWhere((element) => element.id == album.id);
      'Album removed from liked albums'.showSuccessAlert();
    } else {
      final uAlbum = album.copyWith(isLiked: true);
      list.insert(0, uAlbum);
      'Album added to liked albums'.showSuccessAlert();
    }

    _likeManager.likedAlbums = list;
  }

  ///
  static Future<DbAlbumModel?> getAlbumById(String albumId) async {
    final searchRepo = Injector.instance<MusicRepo>();
    DbAlbumModel? album;
    'Searching Album by id : $albumId'.logD;
    final res = await searchRepo.searchAlbumById(ApiRequest(params: {'id': albumId}));

    res.when(
      success: (data) {
        album = data;
      },
      error: (exception) {
        'Search album by Id API failed : $exception'.logE;
        'Failed to add album to local database'.showErrorAlert();
      },
    );

    return album;
  }

  /// Checks if a Album is liked in the local database.
  static bool isAlbumLiked(DbAlbumModel album) {
    final list = _likeManager.likedAlbums;
    return list.any((s) => s.id == album.id);
  }

  /// Checks if a playlist is liked in the local database.
  static bool isPlaylistLiked(DbPlaylistModel playlist) {
    final list = _likeManager.likedPlaylists;
    return list.any((s) => s.id == playlist.id);
  }

  /// Toggles the like status of a playlist in the database.
  static void toggleLikedPlaylist(DbPlaylistModel playlist) {
    final list = _likeManager.likedPlaylists.toList();
    if (list.any((s) => s.id == playlist.id)) {
      list.removeWhere((element) => element.id == playlist.id);
      'Playlist removed from liked playlists'.showSuccessAlert();
    } else {
      final uPlaylist = playlist.copyWith(isLiked: true);
      list.insert(0, uPlaylist);
      'Playlist added to liked playlists'.showSuccessAlert();
    }

    _likeManager.likedPlaylists = list;
  }
}
