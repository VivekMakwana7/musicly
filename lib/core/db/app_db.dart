import 'dart:io';

import 'package:hive_ce/hive.dart';
import 'package:musicly/core/db/models/album/db_album_model.dart';
import 'package:musicly/core/db/models/artist/db_artist_model.dart';
import 'package:musicly/core/db/models/playlist/db_playlist_model.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';
import 'package:musicly/core/di/injector.dart';

/// to store local data
class AppDB {
  AppDB._(this._box);

  static const _appDbBox = '_appDbBox';

  final Box<dynamic> _box;

  /// save value
  T getValue<T>(String key, {T? defaultValue}) => _box.get(key, defaultValue: defaultValue) as T;

  /// save value
  Future<void> setValue<T>(String key, T value) => _box.put(key, value);

  /// to set internet status
  set internetStatus(String status) => setValue('internetStatus', status);

  /// to get internet status
  String get internetStatus => getValue('internetStatus', defaultValue: 'connected');

  /// to check internet connection status is connected or not
  bool get isInternetConnected {
    return internetStatus == 'connected';
  }

  /// to get instance
  static Future<AppDB> getInstance() async {
    await Injector.instance.isReady<Directory>(instanceName: appDocDirInstanceName);
    try {
      final box = await Hive.openBox<dynamic>(_appDbBox);
      return AppDB._(box);
    } on Object {
      final appDir = Injector.instance<Directory>(instanceName: appDocDirInstanceName);
      if (appDir.existsSync()) {
        appDir.deleteSync(recursive: true);
      }
      final box = await Hive.openBox<dynamic>(_appDbBox);
      return AppDB._(box);
    }
  }

  /// to logout user
  Future<void> logoutUser() async {
    await _box.clear();
  }

  /// Stream For Song Search History Update
  Stream<BoxEvent> songSearchHistoryListenable() {
    return _box.watch(key: 'songSearchHistory').asBroadcastStream();
  }

  /// For get Song Search History
  List<DbSongModel> get songSearchHistory {
    final historyList = getValue('songSearchHistory', defaultValue: <dynamic>[]);
    return historyList.map((e) => e as DbSongModel).toList();
  }

  /// For set Song Search History
  set songSearchHistory(List<DbSongModel> history) {
    setValue('songSearchHistory', history);
  }

  /// Check History empty or not
  bool get isHistoryEmpty =>
      songSearchHistory.isEmpty &&
      albumSearchHistory.isEmpty &&
      artistSearchHistory.isEmpty &&
      playlistSearchHistory.isEmpty;

  /// For get Album Search History
  List<DbAlbumModel> get albumSearchHistory {
    final historyList = getValue('albumSearchHistory', defaultValue: <dynamic>[]);
    return historyList.map((e) => e as DbAlbumModel).toList();
  }

  /// For set album Search History
  set albumSearchHistory(List<DbAlbumModel> history) {
    setValue('albumSearchHistory', history);
  }

  /// For get Artist Search History
  List<DbArtistModel> get artistSearchHistory {
    final historyList = getValue('artistSearchHistory', defaultValue: <dynamic>[]);
    return historyList.map((e) => e as DbArtistModel).toList();
  }

  /// For set artist Search History
  set artistSearchHistory(List<DbArtistModel> history) {
    setValue('artistSearchHistory', history);
  }

  /// For get Playlist Search History
  List<DbPlaylistModel> get playlistSearchHistory {
    final historyList = getValue('playlistSearchHistory', defaultValue: <dynamic>[]);
    return historyList.map((e) => e as DbPlaylistModel).toList();
  }

  /// For set Playlist Search History
  set playlistSearchHistory(List<DbPlaylistModel> history) {
    setValue('playlistSearchHistory', history);
  }

  /// For get Liked Songs
  List<DbSongModel> get likedSongs {
    final historyList = getValue('likedSongs', defaultValue: <dynamic>[]);
    return historyList.map((e) => e as DbSongModel).toList();
  }

  /// For set Liked Songs
  set likedSongs(List<DbSongModel> history) {
    setValue('likedSongs', history);
  }

  /// For get Recent Played Songs
  List<DbSongModel> get recentPlayedSong {
    final historyList = getValue('recentPlayedSong', defaultValue: <dynamic>[]);
    return historyList.map((e) => e as DbSongModel).toSet().toList();
  }

  /// For set Recent Played Songs
  set recentPlayedSong(List<DbSongModel> history) {
    setValue('recentPlayedSong', history);
  }

  /// Stream for Recent Played Song Stream
  Stream<BoxEvent> recentPlayedSongStream() {
    return _box.watch(key: 'recentPlayedSong').asBroadcastStream();
  }

  /// Stream for Liked Song Stream
  Stream<BoxEvent> likedSongStream() {
    return _box.watch(key: 'likedSongs').asBroadcastStream();
  }
}
