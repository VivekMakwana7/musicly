import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart' show HiveObject;
import 'package:musicly/core/db/models/image_model.dart';
import 'package:musicly/core/enums/search_item_type.dart';

part 'search_history_model.freezed.dart';

///
@Freezed(copyWith: false, toJson: false, fromJson: false)
sealed class SearchHistoryModel extends HiveObject with _$SearchHistoryModel {
  factory SearchHistoryModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'descripiton') String? descripiton,
    @JsonKey(name: 'url') String? url,
    @JsonKey(name: 'type') SearchItemType? type,
    @JsonKey(name: 'images') List<ImageModel>? images,
  }) = _SearchHistoryModel;

  SearchHistoryModel._();
}
