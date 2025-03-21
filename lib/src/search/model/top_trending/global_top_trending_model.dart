import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:musicly/core/enums/search_item_type.dart';
import 'package:musicly/src/search/model/image/image_response_model.dart';

part 'global_top_trending_model.freezed.dart';
part 'global_top_trending_model.g.dart';

/// Global Search API Top Trending Model
@Freezed(copyWith: false, toJson: false)
sealed class GlobalTopTrendingModel with _$GlobalTopTrendingModel {
  /// Factory Constructor
  const factory GlobalTopTrendingModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'image') List<ImageResponseModel>? image,
    @JsonKey(name: 'album') String? album,
    @JsonKey(name: 'url') String? url,
    @JsonKey(name: 'type', fromJson: fromJsonSearchItemType) @Default(SearchItemType.song) SearchItemType type,
    @JsonKey(name: 'language') String? language,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'primaryArtists') String? primaryArtists,
    @JsonKey(name: 'singers') String? singers,
  }) = _GlobalTopTrendingModel;

  const GlobalTopTrendingModel._();

  /// Factory constructor for from json
  factory GlobalTopTrendingModel.fromJson(Map<String, Object?> json) => _$GlobalTopTrendingModelFromJson(json);
}

/// Get Search Item type based on type
@pragma('vm:entry-point')
SearchItemType fromJsonSearchItemType(String? type) {
  return switch (type) {
    'song' => SearchItemType.song,
    'album' => SearchItemType.album,
    'artist' => SearchItemType.artist,
    'playlist' => SearchItemType.playlist,
    _ => SearchItemType.song,
  };
}
