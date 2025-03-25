import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:musicly/core/db/models/album/db_album_model.dart';

part 'search_album_response_model.freezed.dart';
part 'search_album_response_model.g.dart';

/// Search Album API response Model
@Freezed(toJson: false, copyWith: false)
sealed class SearchAlbumResponseModel with _$SearchAlbumResponseModel {
  /// Factory Constructor
  const factory SearchAlbumResponseModel({
    @JsonKey(name: 'total') int? total,
    @JsonKey(name: 'start') int? start,
    @JsonKey(name: 'results') List<DbAlbumModel>? results,
  }) = _SearchAlbumResponseModel;

  /// Factory constructor for FromJson
  factory SearchAlbumResponseModel.fromJson(Map<String, Object?> json) => _$SearchAlbumResponseModelFromJson(json);
}
