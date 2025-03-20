import 'dart:io';

import 'package:hive_ce/hive.dart';
import 'package:musicly/core/db/models/recent_played_song_model.dart';
import 'package:musicly/core/db/models/search_history_model.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/enums/search_item_type.dart';
import 'package:musicly/src/search/model/album/global_album_model.dart';
import 'package:musicly/src/search/model/artist/global_artist_model.dart';
import 'package:musicly/src/search/model/image/image_response_model.dart';
import 'package:musicly/src/search/model/playlist_model.dart';
import 'package:musicly/src/search/model/result_image_model.dart';
import 'package:musicly/src/search/model/song/global_song_model.dart';

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

  // /// notifies user on value change
  // Stream<BoxEvent> userListenable() {
  //   return _box.watch(key: 'user').asBroadcastStream();
  // }

  /// to logout user
  Future<void> logoutUser() async {
    await _box.clear();
  }

  /// to get searched items
  List<SearchHistoryModel> get searchHistory {
    final searchHistoryList = getValue('searchHistory', defaultValue: <dynamic>[]);
    return searchHistoryList.map((e) => e as SearchHistoryModel).toList();
  }

  /// to store searched items
  set searchHistory(List<SearchHistoryModel> searchHistory) => setValue('searchHistory', searchHistory);

  /// Filter Search History and get Song Result List
  List<GlobalSongModel> get songSearchHistory =>
      searchHistory
          .where((element) => element.type == SearchItemType.song)
          .map(
            (e) => GlobalSongModel(
              id: e.id,
              title: e.title,
              description: e.descripiton,
              url: e.url,
              image: e.images?.map((ele) => ImageResponseModel(quality: ele.quality, url: ele.url)).toList(),
            ),
          )
          .take(5)
          .toList();

  /// Filter Search History and get artist Result List
  List<GlobalArtistModel> get artistSearchHistory =>
      searchHistory
          .where((element) => element.type == SearchItemType.artist)
          .map(
            (e) => GlobalArtistModel(
              id: e.id,
              title: e.title,
              description: e.descripiton,
              image: e.images?.map((ele) => ImageResponseModel(quality: ele.quality, url: ele.url)).toList(),
            ),
          )
          .take(10)
          .toList();

  /// Filter Search History and get album result List
  List<GlobalAlbumModel> get albumSearchHistory =>
      searchHistory
          .where((element) => element.type == SearchItemType.album)
          .map(
            (e) => GlobalAlbumModel(
              id: e.id,
              title: e.title,
              description: e.descripiton,
              image: e.images?.map((ele) => ImageResponseModel(quality: ele.quality, url: ele.url)).toList(),
              url: e.url,
            ),
          )
          .take(6)
          .toList();

  /// Filter Search History and get Play Result List
  List<PlayListResultModel> get playlistSearchHistory =>
      searchHistory
          .where((element) => element.type == SearchItemType.playlist)
          .map(
            (e) => PlayListResultModel(
              id: e.id,
              title: e.title,
              description: e.descripiton,
              image: e.images?.map((ele) => ResultImageModel(quality: ele.quality, url: ele.url)).toList(),
              url: e.url,
            ),
          )
          .take(10)
          .toList();

  /// to get Recent Played Song List
  List<RecentPlayedSongModel> get recentPlayedSongList {
    final searchHistoryList = getValue('recentPlayedSongList', defaultValue: <dynamic>[]);
    return searchHistoryList.map((e) => e as RecentPlayedSongModel).toList();
  }

  /// to store recent Played Song items
  set recentPlayedSongList(List<RecentPlayedSongModel> recentPlayed) => setValue('recentPlayedSongList', recentPlayed);

  /// Stream For Recent Played Song Update
  Stream<BoxEvent> recentPlayedSongStream() {
    return _box.watch(key: 'recentPlayedSongList').asBroadcastStream();
  }
}
