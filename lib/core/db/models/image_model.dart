import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart' show HiveObject;

part 'image_model.freezed.dart';

///
@Freezed(copyWith: false, toJson: false, fromJson: false)
sealed class ImageModel extends HiveObject with _$ImageModel {
  factory ImageModel({@JsonKey(name: 'quality') String? quality, @JsonKey(name: 'url') String? url}) = _ImageModel;

  ImageModel._();
}
