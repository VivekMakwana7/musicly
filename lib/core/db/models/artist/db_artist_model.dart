import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart' show HiveObject;
import 'package:musicly/core/db/models/album/db_album_model.dart';
import 'package:musicly/core/db/models/image/image_model.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';

part 'db_artist_model.freezed.dart';
part 'db_artist_model.g.dart';

/// [DbArtistModel] for store Artist Detail in Database
@Freezed(toJson: false)
sealed class DbArtistModel extends HiveObject with _$DbArtistModel {
  factory DbArtistModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'url') String? url,
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'followerCount') int? followerCount,
    @JsonKey(name: 'fanCount') String? fanCount,
    @JsonKey(name: 'isVerified') bool? isVerified,
    @JsonKey(name: 'dominantLanguage') String? dominantLanguage,
    @JsonKey(name: 'dominantType') String? dominantType,
    @JsonKey(name: 'bio') List<Bio>? bio,
    @JsonKey(name: 'dob') String? dob,
    @JsonKey(name: 'fb') dynamic fb,
    @JsonKey(name: 'twitter') dynamic twitter,
    @JsonKey(name: 'wiki') String? wiki,
    @JsonKey(name: 'availableLanguages') List<String>? availableLanguages,
    @JsonKey(name: 'isRadioPresent') bool? isRadioPresent,
    @JsonKey(name: 'image') List<ImageModel>? image,
    @JsonKey(name: 'topSongs') List<DbSongModel>? topSongs,
    @JsonKey(name: 'topAlbums') List<DbAlbumModel>? topAlbums,
    @JsonKey(name: 'singles') List<DbSongModel>? singles,
    @JsonKey(name: 'similarArtists') List<dynamic>? similarArtists,
  }) = _DbArtistModel;

  DbArtistModel._();

  factory DbArtistModel.fromJson(Map<String, Object?> json) => _$DbArtistModelFromJson(json);
}

/// [Bio] for Current Artist Bio details
@Freezed(toJson: false, copyWith: false)
sealed class Bio extends HiveObject with _$Bio {
  factory Bio({
    @JsonKey(name: 'text') String? text,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'sequence') int? sequence,
  }) = _Bio;

  Bio._();
  factory Bio.fromJson(Map<String, Object?> json) => _$BioFromJson(json);
}
