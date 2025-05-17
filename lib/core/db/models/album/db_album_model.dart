import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart' show HiveObject;
import 'package:musicly/core/db/models/image/image_model.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';

part 'db_album_model.freezed.dart';
part 'db_album_model.g.dart';

/// [DbAlbumModel] for local database
@Freezed(toJson: false)
sealed class DbAlbumModel extends HiveObject with _$DbAlbumModel {
  factory DbAlbumModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'year') int? year,
    @JsonKey(name: 'playCount') dynamic playCount,
    @JsonKey(name: 'language') String? language,
    @JsonKey(name: 'explicitContent') bool? explicitContent,
    @JsonKey(name: 'url') String? url,
    @JsonKey(name: 'songCount') int? songCount,
    @JsonKey(name: 'artists') DbSongArtist? artists,
    @JsonKey(name: 'image') List<ImageModel>? image,
    @JsonKey(name: 'songs') List<DbSongModel>? songs,
    @JsonKey(name: 'isLiked') @Default(false) bool isLiked,
  }) = _DbAlbumModel;

  DbAlbumModel._();

  factory DbAlbumModel.fromJson(Map<String, Object?> json) => _$DbAlbumModelFromJson(json);

  /// Get List of [DbAlbumModel] from Json
  static List<DbAlbumModel> fromJsonList(List<dynamic> json) =>
      json.map((e) => DbAlbumModel.fromJson(e as Map<String, dynamic>)).toList();
}
