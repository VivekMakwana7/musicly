import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:musicly/core/db/models/image_model.dart';
import 'package:musicly/core/db/models/search_history_model.dart';
import 'package:musicly/core/enums/search_item_type.dart';
import 'package:musicly/src/search/model/image/image_response_model.dart';

part 'global_artist_model.freezed.dart';
part 'global_artist_model.g.dart';

/// Global Search API Artist Model
@Freezed(copyWith: false, toJson: false)
sealed class GlobalArtistModel with _$GlobalArtistModel {
  /// Factory Constructor
  const factory GlobalArtistModel({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'image') List<ImageResponseModel>? image,
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'position') int? position,
  }) = _GlobalArtistModel;

  /// Factory constructor for from json
  factory GlobalArtistModel.fromJson(Map<String, Object?> json) => _$GlobalArtistModelFromJson(json);

  const GlobalArtistModel._();

  /// Convert to Search History Model
  SearchHistoryModel toSearchHistoryModel() {
    return SearchHistoryModel(
      id: id!,
      title: title ?? '',
      descripiton: description,
      type: SearchItemType.artist,
      images: image?.map((e) => ImageModel(url: e.url, quality: e.quality)).toList(),
    );
  }
}
