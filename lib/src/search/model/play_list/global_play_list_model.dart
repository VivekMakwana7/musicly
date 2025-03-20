import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:musicly/src/search/model/image/image_response_model.dart';

part 'global_play_list_model.freezed.dart';
part 'global_play_list_model.g.dart';

/// Global Search API response Play List Model
@Freezed(copyWith: false, toJson: false)
sealed class GlobalPlayListModel with _$GlobalPlayListModel {
  /// Factory Constructor
  const factory GlobalPlayListModel({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'image') List<ImageResponseModel>? image,
    @JsonKey(name: 'url') String? url,
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'language') String? language,
    @JsonKey(name: 'description') String? description,
  }) = _GlobalPlayListModel;

  /// Factory Constructor for from Json
  factory GlobalPlayListModel.fromJson(Map<String, Object?> json) => _$GlobalPlayListModelFromJson(json);
}
