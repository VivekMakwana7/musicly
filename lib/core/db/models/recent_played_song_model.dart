import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart' show HiveObject;
import 'package:musicly/core/db/models/image_model.dart';

part 'recent_played_song_model.freezed.dart';

///
@Freezed(copyWith: false, toJson: false, fromJson: false)
sealed class RecentPlayedSongModel extends HiveObject with _$RecentPlayedSongModel {
  factory RecentPlayedSongModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'descripiton') String? descripiton,
    @JsonKey(name: 'url') String? url,
    @JsonKey(name: 'images') List<ImageModel>? images,
  }) = _RecentPlayedSongModel;

  RecentPlayedSongModel._();
}
