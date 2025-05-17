import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:musicly/core/db/models/album/db_album_model.dart';

part 'artist_album_model.freezed.dart';
part 'artist_album_model.g.dart';

/// Artist Album Response Model
@Freezed(toJson: false, copyWith: false)
sealed class ArtistAlbumModel with _$ArtistAlbumModel {
  /// Factory Constructor
  const factory ArtistAlbumModel({
    @JsonKey(name: 'total') int? total,
    @JsonKey(name: 'albums') List<DbAlbumModel>? albums,
  }) = _ArtistAlbumModel;

  /// Factory constructor for FromJson
  factory ArtistAlbumModel.fromJson(Map<String, Object?> json) => _$ArtistAlbumModelFromJson(json);
}
