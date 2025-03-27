import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';

part 'artist_song_model.freezed.dart';
part 'artist_song_model.g.dart';

/// Artist Song Response Model
@Freezed(toJson: false, copyWith: false)
sealed class ArtistSongModel with _$ArtistSongModel {
  /// Factory Constructor
  const factory ArtistSongModel({
    @JsonKey(name: 'total') int? total,
    @JsonKey(name: 'songs') List<DbSongModel>? songs,
  }) = _ArtistSongModel;

  /// Factory constructor for FromJson
  factory ArtistSongModel.fromJson(Map<String, Object?> json) => _$ArtistSongModelFromJson(json);
}
