import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart' show HiveObject;
import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/db/models/download_url/db_download_url.dart';
import 'package:musicly/core/db/models/image/image_model.dart';

part 'db_song_model.freezed.dart';
part 'db_song_model.g.dart';

/// [DbSongModel] for local database
@Freezed(toJson: false)
sealed class DbSongModel extends HiveObject with _$DbSongModel {
  /// Factory Constructor
  factory DbSongModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'year') String? year,
    @JsonKey(name: 'releaseDate') dynamic releaseDate,
    @JsonKey(name: 'duration') int? duration,
    @JsonKey(name: 'label') String? label,
    @JsonKey(name: 'explicitContent') bool? explicitContent,
    @JsonKey(name: 'playCount') int? playCount,
    @JsonKey(name: 'language') String? language,
    @JsonKey(name: 'hasLyrics') bool? hasLyrics,
    @JsonKey(name: 'lyricsId') dynamic lyricsId,
    @JsonKey(name: 'url') String? url,
    @JsonKey(name: 'copyright') String? copyright,
    @JsonKey(name: 'album') DbSongAlbum? album,
    @JsonKey(name: 'artists') DbSongArtist? artists,
    @JsonKey(name: 'image') List<ImageModel>? image,
    @JsonKey(name: 'downloadUrl') List<DbDownloadUrl>? downloadUrl,
    @JsonKey(name: 'device_path') String? devicePath,
    @Default(false) bool isLiked,
  }) = _DbSongModel;

  DbSongModel._();

  /// Factory constructor for FromJson
  factory DbSongModel.fromJson(Map<String, Object?> json) => _$DbSongModelFromJson(json);

  /// Get list of [DbSongModel] from json
  static List<DbSongModel> fromJsonList(List<dynamic> json) =>
      json.map((e) => DbSongModel.fromJson(e as Map<String, dynamic>)).toList();

  /// For get Audio URL
  String? get audioUrl =>
      devicePath ??
      (downloadUrl != null && downloadUrl!.isNotEmpty
          ? downloadUrl!.firstWhere((e) => e.quality == AppDB.settingManager.songQuality).url
          : null);

  /// For download Song with given quality
  String? downloadURL(String quality) {
    return downloadUrl != null && downloadUrl!.isNotEmpty
        ? downloadUrl!.firstWhere((e) => e.quality == quality).url
        : null;
  }
}

/// [DbSongArtist] for Current Song's Artist details
@Freezed(toJson: false, copyWith: false)
sealed class DbSongArtist extends HiveObject with _$DbSongArtist {
  factory DbSongArtist({
    @JsonKey(name: 'primary') List<DbSongPrimaryArtist>? primary,
    @JsonKey(name: 'featured') List<dynamic>? featured,
    @JsonKey(name: 'all') List<DbSongAllArtist>? all,
  }) = _DbSongArtist;

  DbSongArtist._();

  factory DbSongArtist.fromJson(Map<String, Object?> json) => _$DbSongArtistFromJson(json);
}

/// [DbSongAllArtist] for All Artist details
@Freezed(toJson: false, copyWith: false)
sealed class DbSongAllArtist extends HiveObject with _$DbSongAllArtist {
  factory DbSongAllArtist({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'role') String? role,
    @JsonKey(name: 'image') List<ImageModel>? image,
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'url') String? url,
  }) = _DbSongAllArtist;

  DbSongAllArtist._();

  factory DbSongAllArtist.fromJson(Map<String, Object?> json) => _$DbSongAllArtistFromJson(json);
}

/// [DbSongPrimaryArtist] for Primary Artist details
@Freezed(toJson: false, copyWith: false)
sealed class DbSongPrimaryArtist extends HiveObject with _$DbSongPrimaryArtist {
  factory DbSongPrimaryArtist({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'role') String? role,
    @JsonKey(name: 'image') List<ImageModel>? image,
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'url') String? url,
  }) = _DbSongPrimaryArtist;

  DbSongPrimaryArtist._();
  factory DbSongPrimaryArtist.fromJson(Map<String, Object?> json) => _$DbSongPrimaryArtistFromJson(json);
}

/// [DbSongAlbum] for display available Album based on current song
@Freezed(toJson: false, copyWith: false)
sealed class DbSongAlbum extends HiveObject with _$DbSongAlbum {
  factory DbSongAlbum({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'url') String? url,
  }) = _DbSongAlbum;

  DbSongAlbum._();

  factory DbSongAlbum.fromJson(Map<String, Object?> json) => _$DbSongAlbumFromJson(json);
}
