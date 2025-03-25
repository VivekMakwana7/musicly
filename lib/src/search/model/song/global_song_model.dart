import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:musicly/src/search/model/image/image_response_model.dart';

part 'global_song_model.freezed.dart';
part 'global_song_model.g.dart';

/// Global Search API song Model
@Freezed(copyWith: false, toJson: false)
sealed class GlobalSongModel with _$GlobalSongModel {
  /// Factory Constructor
  const factory GlobalSongModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'image') List<ImageResponseModel>? image,
    @JsonKey(name: 'album') String? album,
    @JsonKey(name: 'url') String? url,
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'primaryArtists') String? primaryArtists,
    @JsonKey(name: 'singers') String? singers,
    @JsonKey(name: 'language') String? language,
  }) = _GlobalSongModel;

  /// Factory constructor for from json
  factory GlobalSongModel.fromJson(Map<String, Object?> json) => _$GlobalSongModelFromJson(json);

  const GlobalSongModel._();
}
