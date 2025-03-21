import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:musicly/src/search/model/image/image_response_model.dart';

part 'global_album_model.freezed.dart';
part 'global_album_model.g.dart';

/// Global Search API Album Model
@Freezed(copyWith: false, toJson: false)
sealed class GlobalAlbumModel with _$GlobalAlbumModel {
  /// Factory Constructor
  const factory GlobalAlbumModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'image') List<ImageResponseModel>? image,
    @JsonKey(name: 'artist') String? artist,
    @JsonKey(name: 'url') String? url,
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'year') String? year,
    @JsonKey(name: 'songIds') String? songIds,
    @JsonKey(name: 'language') String? language,
  }) = _GlobalAlbumModel;

  /// Factory constructor for from json
  factory GlobalAlbumModel.fromJson(Map<String, Object?> json) => _$GlobalAlbumModelFromJson(json);

  const GlobalAlbumModel._();
}
