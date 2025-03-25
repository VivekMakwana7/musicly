import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart' show HiveObject;
import 'package:musicly/core/db/models/image/image_model.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';

part 'db_playlist_model.freezed.dart';
part 'db_playlist_model.g.dart';

/// [DbPlaylistModel] for store Playlist details in database
@Freezed(toJson: false)
sealed class DbPlaylistModel extends HiveObject with _$DbPlaylistModel {
  /// [DbPlaylistModel] constructor
  factory DbPlaylistModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'year') dynamic year,
    @JsonKey(name: 'playCount') dynamic playCount,
    @JsonKey(name: 'language') String? language,
    @JsonKey(name: 'explicitContent') bool? explicitContent,
    @JsonKey(name: 'url') String? url,
    @JsonKey(name: 'songCount') int? songCount,
    @JsonKey(name: 'artists') List<DbSongPrimaryArtist>? artists,
    @JsonKey(name: 'image') List<ImageModel>? image,
    @JsonKey(name: 'songs') List<DbSongModel>? songs,
  }) = _DbPlaylistModel;

  DbPlaylistModel._();

  factory DbPlaylistModel.fromJson(Map<String, Object?> json) => _$DbPlaylistModelFromJson(json);
}
