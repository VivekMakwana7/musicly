import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart' show HiveObject;

part 'image_model.freezed.dart';
part 'image_model.g.dart';

/// [ImageModel] for common use for store Image related data in database
@Freezed(copyWith: false)
sealed class ImageModel extends HiveObject with _$ImageModel {
  factory ImageModel({@JsonKey(name: 'quality') String? quality, @JsonKey(name: 'url') String? url}) = _ImageModel;

  // Required when we are using HiveObject
  ImageModel._();

  factory ImageModel.fromJson(Map<String, Object?> json) => _$ImageModelFromJson(json);
}
