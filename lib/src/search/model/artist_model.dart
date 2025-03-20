import 'package:flutter/material.dart';
import 'package:musicly/core/db/models/image_model.dart';
import 'package:musicly/core/db/models/search_history_model.dart';
import 'package:musicly/core/enums/search_item_type.dart';
import 'package:musicly/src/search/model/result_image_model.dart';

/// Artists Model
@immutable
class ArtistModel {
  /// Artists constructor
  const ArtistModel({this.results, this.position});

  /// Creates a [ArtistModel] from a Json object.
  factory ArtistModel.fromJson(Map<String, dynamic> data) => ArtistModel(
    results:
        (data['results'] as List<dynamic>?)?.map((e) => ArtistResultModel.fromJson(e as Map<String, dynamic>)).toList(),
    position: data['position'] as int?,
  );

  /// List of Results
  final List<ArtistResultModel>? results;

  /// The position of the artist in the search results.
  final int? position;
}

/// Result Model
@immutable
class ArtistResultModel {
  /// Result constructor
  const ArtistResultModel({this.id, this.title, this.image, this.description});

  /// Creates a [ArtistResultModel] from a Json object.
  factory ArtistResultModel.fromJson(Map<String, dynamic> data) => ArtistResultModel(
    id: data['id'] as String?,
    title: data['title'] as String?,
    image: (data['image'] as List<dynamic>?)?.map((e) => ResultImageModel.fromMap(e as Map<String, dynamic>)).toList(),
    description: data['description'] as String?,
  );

  /// Result Id
  final String? id;

  /// Result Title
  final String? title;

  /// Result Image
  final List<ResultImageModel>? image;

  /// Result Description
  final String? description;

  /// Convert Result Model to Search History Model
  SearchHistoryModel toSearchHistoryModel() => SearchHistoryModel(
    id: id ?? '',
    title: title ?? '',
    type: SearchItemType.artist,
    descripiton: description ?? '',
    images:
        image != null && image!.isNotEmpty
            ? image!.map((e) => ImageModel(quality: e.quality, url: e.url)).toList()
            : null,
  );
}
