import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:musicly/src/search/model/album/global_album_model.dart';
import 'package:musicly/src/search/model/artist/global_artist_model.dart';
import 'package:musicly/src/search/model/play_list/global_play_list_model.dart';
import 'package:musicly/src/search/model/song/global_song_model.dart';
import 'package:musicly/src/search/model/top_trending/global_top_trending_model.dart';

part 'global_search_model.freezed.dart';
part 'global_search_model.g.dart';

/// Global Search API response Model
@Freezed(copyWith: false, toJson: false)
sealed class GlobalSearchModel with _$GlobalSearchModel {
  /// Factory Constructor
  const factory GlobalSearchModel({
    @JsonKey(name: 'topQuery', fromJson: fromJsonTopTrendingModel)
    @Default([])
    List<GlobalTopTrendingModel> topTrending,
    @JsonKey(name: 'songs', fromJson: fromJsonSongModel) @Default([]) List<GlobalSongModel> songs,
    @JsonKey(name: 'albums', fromJson: fromJsonAlbumModel) @Default([]) List<GlobalAlbumModel> albums,
    @JsonKey(name: 'artists', fromJson: fromJsonArtistModel) @Default([]) List<GlobalArtistModel> artists,
    @JsonKey(name: 'playlists', fromJson: fromJsonPlayListModel) @Default([]) List<GlobalPlayListModel> playlists,
  }) = _GlobalSearchModel;

  /// Factory Constructor for from Json
  factory GlobalSearchModel.fromJson(Map<String, Object?> json) => _$GlobalSearchModelFromJson(json);
}

/// Convert Map to List of top trending Model
@pragma('vm:entry-point')
List<GlobalTopTrendingModel> fromJsonTopTrendingModel(Map<String, dynamic> json) {
  if (json['results'] != null) {
    return (json['results'] as List<dynamic>)
        .map((e) => GlobalTopTrendingModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
  return [];
}

/// Convert Map to List of Song Model
@pragma('vm:entry-point')
List<GlobalSongModel> fromJsonSongModel(Map<String, dynamic> json) {
  if (json['results'] != null) {
    return (json['results'] as List<dynamic>).map((e) => GlobalSongModel.fromJson(e as Map<String, dynamic>)).toList();
  }
  return [];
}

/// Convert Map to List of Album Model
@pragma('vm:entry-point')
List<GlobalAlbumModel> fromJsonAlbumModel(Map<String, dynamic> json) {
  if (json['results'] != null) {
    return (json['results'] as List<dynamic>).map((e) => GlobalAlbumModel.fromJson(e as Map<String, dynamic>)).toList();
  }
  return [];
}

/// Convert Map to List of Artist Model
@pragma('vm:entry-point')
List<GlobalArtistModel> fromJsonArtistModel(Map<String, dynamic> json) {
  if (json['results'] != null) {
    return (json['results'] as List<dynamic>)
        .map((e) => GlobalArtistModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
  return [];
}

/// Convert Map to List of Play List Model
@pragma('vm:entry-point')
List<GlobalPlayListModel> fromJsonPlayListModel(Map<String, dynamic> json) {
  if (json['results'] != null) {
    return (json['results'] as List<dynamic>)
        .map((e) => GlobalPlayListModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
  return [];
}
