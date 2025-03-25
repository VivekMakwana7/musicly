import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:musicly/core/db/models/artist/db_artist_model.dart';

part 'search_artist_response_model.freezed.dart';
part 'search_artist_response_model.g.dart';

/// Search Song API response Model
@Freezed(toJson: false, copyWith: false)
sealed class SearchArtistResponseModel with _$SearchArtistResponseModel {
  /// Factory Constructor
  const factory SearchArtistResponseModel({
    @JsonKey(name: 'total') int? total,
    @JsonKey(name: 'start') int? start,
    @JsonKey(name: 'results') List<DbArtistModel>? results,
  }) = _SearchArtistResponseModel;

  /// Factory constructor for FromJson
  factory SearchArtistResponseModel.fromJson(Map<String, Object?> json) => _$SearchArtistResponseModelFromJson(json);
}
