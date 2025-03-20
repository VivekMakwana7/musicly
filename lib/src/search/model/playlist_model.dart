import 'package:flutter/material.dart';
import 'package:musicly/src/search/model/result_image_model.dart';

/// Playlists Model
@immutable
class PlaylistModel {
  /// Playlists constructor
  const PlaylistModel({this.results, this.position});

  /// Creates a [PlaylistModel] from a Json object.
  factory PlaylistModel.fromJson(Map<String, dynamic> data) => PlaylistModel(
    results:
        (data['results'] as List<dynamic>?)
            ?.map((e) => PlayListResultModel.fromJson(e as Map<String, dynamic>))
            .toList(),
    position: data['position'] as int?,
  );

  /// Playlists Results
  final List<PlayListResultModel>? results;

  /// Playlists Position
  final int? position;
}

/// Result Model
@immutable
class PlayListResultModel {
  /// Result constructor
  const PlayListResultModel({this.id, this.title, this.image, this.description, this.url});

  /// Creates a [PlayListResultModel] from a Json object.
  factory PlayListResultModel.fromJson(Map<String, dynamic> data) => PlayListResultModel(
    id: data['id'] as String?,
    title: data['title'] as String?,
    image: (data['image'] as List<dynamic>?)?.map((e) => ResultImageModel.fromMap(e as Map<String, dynamic>)).toList(),
    description: data['description'] as String?,
    url: data['url'] as String?,
  );

  /// Result Id
  final String? id;

  /// Result Title
  final String? title;

  /// Result Image
  final List<ResultImageModel>? image;

  /// Result Description
  final String? description;

  /// Result Url
  final String? url;
}
