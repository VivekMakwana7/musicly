import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart' show HiveObject;

part 'db_download_url.freezed.dart';
part 'db_download_url.g.dart';

/// [DbDownloadUrl] for Download URL based on quality
@freezed
sealed class DbDownloadUrl extends HiveObject with _$DbDownloadUrl {
  /// Factory constructor
  factory DbDownloadUrl({
    @JsonKey(name: 'quality') required String quality,
    @JsonKey(name: 'url') required String url,
  }) = _DbDownloadUrl;

  // Required when we are using HiveObject
  DbDownloadUrl._();

  /// Factory constructor for FromJson
  factory DbDownloadUrl.fromJson(Map<String, Object?> json) => _$DbDownloadUrlFromJson(json);
}
