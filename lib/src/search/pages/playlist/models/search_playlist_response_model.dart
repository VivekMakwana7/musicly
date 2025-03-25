import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:musicly/core/db/models/playlist/db_playlist_model.dart';

part 'search_playlist_response_model.freezed.dart';
part 'search_playlist_response_model.g.dart';

/// Search Playlist API response Model
@Freezed(toJson: false, copyWith: false)
sealed class SearchPlaylistResponseModel with _$SearchPlaylistResponseModel {
  /// Factory Constructor
  const factory SearchPlaylistResponseModel({
    @JsonKey(name: 'total') int? total,
    @JsonKey(name: 'start') int? start,
    @JsonKey(name: 'results') List<DbPlaylistModel>? results,
  }) = _SearchPlaylistResponseModel;

  /// Factory constructor for FromJson
  factory SearchPlaylistResponseModel.fromJson(Map<String, Object?> json) =>
      _$SearchPlaylistResponseModelFromJson(json);
}
