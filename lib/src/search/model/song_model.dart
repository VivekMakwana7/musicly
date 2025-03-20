import 'package:flutter/material.dart';
import 'package:musicly/core/db/models/image_model.dart';
import 'package:musicly/core/db/models/recent_played_song_model.dart';
import 'package:musicly/core/db/models/search_history_model.dart';
import 'package:musicly/core/enums/search_item_type.dart';
import 'package:musicly/src/search/model/result_image_model.dart';

/// Songs Model
@immutable
class SongModel {
  /// Songs constructor
  const SongModel({this.results, this.position});

  /// Creates a [SongModel] from a Json object.
  factory SongModel.fromJson(Map<String, dynamic> data) => SongModel(
    results:
        (data['results'] as List<dynamic>?)?.map((e) => SongResultModel.fromJson(e as Map<String, dynamic>)).toList(),
    position: data['position'] as int?,
  );

  /// List of results
  final List<SongResultModel>? results;

  /// Position of results
  final int? position;
}

/// Result Model
@immutable
class SongResultModel {
  /// Result constructor
  const SongResultModel({this.id, this.title, this.image, this.description, this.album, this.url, this.artist});

  /// Creates a [SongResultModel] from a Json object.
  factory SongResultModel.fromJson(Map<String, dynamic> data) => SongResultModel(
    id: data['id'] as String?,
    title: data['title'] as String?,
    image: (data['image'] as List<dynamic>?)?.map((e) => ResultImageModel.fromMap(e as Map<String, dynamic>)).toList(),
    description: data['description'] as String?,
    album: data['album'] as String?,
    url: data['url'] as String?,
    artist: data['primaryArtists'] as String?,
  );

  /// Result Id
  final String? id;

  /// Result Title
  final String? title;

  /// Result Image
  final List<ResultImageModel>? image;

  /// Result Description
  final String? description;

  /// Song Album name
  final String? album;

  /// Song URL
  final String? url;

  /// Song Artist name
  final String? artist;

  /// Convert Result Model to Search History Model
  SearchHistoryModel toSearchHistoryModel() => SearchHistoryModel(
    id: id ?? '',
    title: title ?? '',
    type: SearchItemType.song,
    descripiton: description ?? '',
    url: url,
    images:
        image != null && image!.isNotEmpty
            ? image!.map((e) => ImageModel(quality: e.quality, url: e.url)).toList()
            : null,
  );

  /// Convert Result Model to Recent Played Song Model
  RecentPlayedSongModel toRecentPlayedSongModel() => RecentPlayedSongModel(
    id: id ?? '',
    title: title ?? '',
    descripiton: description ?? '',
    images:
        image != null && image!.isNotEmpty
            ? image!.map((e) => ImageModel(quality: e.quality, url: e.url)).toList()
            : null,
    url: url,
  );
}
