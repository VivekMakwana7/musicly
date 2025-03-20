import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_response_model.freezed.dart';
part 'image_response_model.g.dart';

/// Image Response Model
@Freezed(copyWith: false, toJson: false)
sealed class ImageResponseModel with _$ImageResponseModel {
  /// Factory Constructor
  const factory ImageResponseModel({@JsonKey(name: 'quality') String? quality, @JsonKey(name: 'url') String? url}) =
      _ImageResponseModel;

  /// Factory constructor for from json
  factory ImageResponseModel.fromJson(Map<String, Object?> json) => _$ImageResponseModelFromJson(json);
}
