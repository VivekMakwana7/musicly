import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart' show HiveObject;
import 'package:musicly/core/db/models/song/db_song_model.dart';

part 'db_song_playlist_model.freezed.dart';
part 'db_song_playlist_model.g.dart';

/// [DbSongPlaylistModel] for common use for store Song Playlist
@Freezed(toJson: false)
sealed class DbSongPlaylistModel extends HiveObject with _$DbSongPlaylistModel {
  factory DbSongPlaylistModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'image') required String image,
    @JsonKey(name: 'songs') @Default([]) List<DbSongModel> songs,
  }) = _DbSongPlaylistModel;

  // Required when we are using HiveObject
  DbSongPlaylistModel._();

  factory DbSongPlaylistModel.fromJson(Map<String, Object?> json) => _$DbSongPlaylistModelFromJson(json);
}
