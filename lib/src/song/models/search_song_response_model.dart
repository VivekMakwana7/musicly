import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';

part 'search_song_response_model.freezed.dart';
part 'search_song_response_model.g.dart';

/// Search Song API response Model
@Freezed(toJson: false, copyWith: false)
sealed class SearchSongResponseModel with _$SearchSongResponseModel {
  /// Factory Constructor
  const factory SearchSongResponseModel({
    @JsonKey(name: 'total') int? total,
    @JsonKey(name: 'start') int? start,
    @JsonKey(name: 'results') List<DbSongModel>? results,
  }) = _SearchSongResponseModel;

  /// Factory constructor for FromJson
  factory SearchSongResponseModel.fromJson(Map<String, Object?> json) => _$SearchSongResponseModelFromJson(json);
}
