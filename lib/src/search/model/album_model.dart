import 'package:flutter/material.dart';
import 'package:musicly/core/db/models/image_model.dart';
import 'package:musicly/core/db/models/search_history_model.dart';
import 'package:musicly/core/enums/search_item_type.dart';
import 'package:musicly/src/search/model/result_image_model.dart';

/// Album Model
class AlbumModel {
  /// Album constructor
  AlbumModel({this.results, this.position});

  /// Creates a [AlbumModel] from a Json object.
  factory AlbumModel.fromJson(Map<String, dynamic> data) => AlbumModel(
    results:
        (data['results'] as List<dynamic>?)?.map((e) => AlbumResultModel.fromJson(e as Map<String, dynamic>)).toList(),
    position: data['position'] as int?,
  );

  /// A list of [AlbumResultModel]s.
  List<AlbumResultModel>? results;

  /// The position of the album in the search results.
  int? position;
}

/// Result Model
@immutable
class AlbumResultModel {
  /// Result constructor
  const AlbumResultModel({this.id, this.title, this.image, this.description, this.artist, this.url, this.songIds});

  /// Creates a [AlbumResultModel] from a Json object.
  factory AlbumResultModel.fromJson(Map<String, dynamic> data) => AlbumResultModel(
    id: data['id'] as String?,
    title: data['title'] as String?,
    image: (data['image'] as List<dynamic>?)?.map((e) => ResultImageModel.fromMap(e as Map<String, dynamic>)).toList(),
    description: data['description'] as String?,
    artist: data['artist'] as String?,
    url: data['url'] as String?,
    songIds: data['songIds'] as String?,
  );

  /// Result Id
  final String? id;

  /// Result Title
  final String? title;

  /// Result Image
  final List<ResultImageModel>? image;

  /// Result Description
  final String? description;

  /// Artist name
  final String? artist;

  /// URL
  final String? url;

  /// Song Ids
  final String? songIds;

  /// Convert Result Model to Search History Model
  SearchHistoryModel toSearchHistoryModel() => SearchHistoryModel(
    id: id ?? '',
    title: title ?? '',
    type: SearchItemType.album,
    descripiton: description ?? '',
    url: url,
    images:
        image != null && image!.isNotEmpty
            ? image!.map((e) => ImageModel(quality: e.quality, url: e.url)).toList()
            : null,
  );
}
