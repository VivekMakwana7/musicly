import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:musicly/core/db/models/image/image_model.dart';
import 'package:musicly/core/db/models/search_history_model.dart';
import 'package:musicly/core/enums/search_item_type.dart';
import 'package:musicly/src/search/model/image/image_response_model.dart';

part 'global_play_list_model.freezed.dart';
part 'global_play_list_model.g.dart';

/// Global Search API response Play List Model
@Freezed(copyWith: false, toJson: false)
sealed class GlobalPlayListModel with _$GlobalPlayListModel {
  /// Factory Constructor
  const factory GlobalPlayListModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'image') List<ImageResponseModel>? image,
    @JsonKey(name: 'url') String? url,
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'language') String? language,
    @JsonKey(name: 'description') String? description,
  }) = _GlobalPlayListModel;

  /// Factory Constructor for from Json
  factory GlobalPlayListModel.fromJson(Map<String, Object?> json) => _$GlobalPlayListModelFromJson(json);

  /// Private Constructor
  const GlobalPlayListModel._();

  /// Convert to Search History Model
  SearchHistoryModel toSearchHistoryModel() {
    return SearchHistoryModel(
      id: id,
      title: title ?? '',
      images: image?.map((e) => ImageModel(quality: e.quality, url: e.url)).toList(),
      type: SearchItemType.playlist,
      url: url,
      descripiton: description,
    );
  }
}
