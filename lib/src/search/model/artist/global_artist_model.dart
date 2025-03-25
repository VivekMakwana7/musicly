import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:musicly/src/search/model/image/image_response_model.dart';

part 'global_artist_model.freezed.dart';
part 'global_artist_model.g.dart';

/// Global Search API Artist Model
@Freezed(copyWith: false, toJson: false)
sealed class GlobalArtistModel with _$GlobalArtistModel {
  /// Factory Constructor
  const factory GlobalArtistModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'image') List<ImageResponseModel>? image,
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'position') int? position,
  }) = _GlobalArtistModel;

  /// Factory constructor for from json
  factory GlobalArtistModel.fromJson(Map<String, Object?> json) => _$GlobalArtistModelFromJson(json);

  const GlobalArtistModel._();
}
