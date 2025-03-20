import 'package:flutter/material.dart';
import 'package:musicly/core/db/models/image_model.dart';
import 'package:musicly/core/db/models/search_history_model.dart';
import 'package:musicly/core/enums/search_item_type.dart';
import 'package:musicly/src/search/model/result_image_model.dart';

/// TopQuery Model
@immutable
class TopQueryModel {
  /// TopQuery constructor
  const TopQueryModel({this.results, this.position});

  /// Creates a [TopQueryModel] from a Json object.
  factory TopQueryModel.fromJson(Map<String, dynamic> data) => TopQueryModel(
    results:
        (data['results'] as List<dynamic>?)
            ?.map((e) => TopQueryResultModel.fromJson(e as Map<String, dynamic>))
            .toList(),
    position: data['position'] as int?,
  );

  /// List of Result
  final List<TopQueryResultModel>? results;

  /// Position
  final int? position;
}

/// Result Model
@immutable
class TopQueryResultModel {
  /// Result constructor
  const TopQueryResultModel({
    this.id,
    this.title,
    this.image,
    this.type,
    this.description,
    this.album,
    this.singers,
    this.url,
  });

  /// Creates a [TopQueryResultModel] from a Json object.
  factory TopQueryResultModel.fromJson(Map<String, dynamic> data) => TopQueryResultModel(
    id: data['id'] as String?,
    title: data['title'] as String?,
    image: (data['image'] as List<dynamic>?)?.map((e) => ResultImageModel.fromMap(e as Map<String, dynamic>)).toList(),
    type: ((data['type'] as String?) == 'song') ? SearchItemType.song : null,
    description: data['description'] as String?,
  );

  /// Result Id
  final String? id;

  /// Result Title
  final String? title;

  /// Result Image
  final List<ResultImageModel>? image;

  /// Result Type
  final SearchItemType? type;

  /// Result Description
  final String? description;

  /// Song Album
  final String? album;

  /// Song Url
  final String? url;

  /// Song Singers
  final String? singers;

  /// Convert Result Model to Search History Model
  SearchHistoryModel toSearchHistoryModel() => SearchHistoryModel(
    id: id ?? '',
    title: title ?? '',
    type: type,
    descripiton: description ?? '',
    url: url,
    images:
        image != null && image!.isNotEmpty
            ? image!.map((e) => ImageModel(quality: e.quality, url: e.url)).toList()
            : null,
  );
}
