import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:musicly/core/db/models/image_model.dart';
import 'package:musicly/core/db/models/recent_played_song_model.dart';
import 'package:musicly/core/db/models/search_history_model.dart';
import 'package:musicly/core/enums/search_item_type.dart';
import 'package:musicly/src/search/model/image/image_response_model.dart';

part 'global_song_model.freezed.dart';
part 'global_song_model.g.dart';

/// Global Search API song Model
@Freezed(copyWith: false, toJson: false)
sealed class GlobalSongModel with _$GlobalSongModel {
  /// Factory Constructor
  const factory GlobalSongModel({
    @JsonKey(name: 'id') String? id,
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

  /// Convert to Search History Model
  SearchHistoryModel toSearchHistoryModel() {
    return SearchHistoryModel(
      id: id!,
      title: title ?? '',
      url: url,
      descripiton: description,
      type: SearchItemType.song,
      images: image?.map((e) => ImageModel(url: e.url, quality: e.quality)).toList(),
    );
  }

  /// Convert to recent played song model
  RecentPlayedSongModel toRecentPlayedSongModel() {
    return RecentPlayedSongModel(
      id: id!,
      title: title ?? '',
      url: url,
      images: image?.map((e) => ImageModel(url: e.url, quality: e.quality)).toList(),
      descripiton: description,
    );
  }
}
