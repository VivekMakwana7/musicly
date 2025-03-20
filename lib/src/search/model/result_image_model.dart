import 'dart:convert';

/// Image Model
class ResultImageModel {
  /// Image constructor
  ResultImageModel({this.quality, this.url});

  /// Creates a [ResultImageModel] from a Json object.
  factory ResultImageModel.fromMap(Map<String, dynamic> data) =>
      ResultImageModel(quality: data['quality'] as String?, url: data['url'] as String?);

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ResultImageModel].
  factory ResultImageModel.fromJson(String data) {
    return ResultImageModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// Image Quality
  String? quality;

  /// Image Url
  String? url;

  /// To Map
  Map<String, dynamic> toMap() => {'quality': quality, 'url': url};
}
