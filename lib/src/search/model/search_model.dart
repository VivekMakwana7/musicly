import 'package:musicly/src/search/model/album_model.dart';
import 'package:musicly/src/search/model/artist_model.dart';
import 'package:musicly/src/search/model/playlist_model.dart';
import 'package:musicly/src/search/model/song_model.dart';
import 'package:musicly/src/search/model/top_query_model.dart';

/// Search Model
class SearchModel {
  /// SearchModel constructor
  SearchModel({this.topQuery, this.songs, this.albums, this.artists, this.playlists});

  /// Creates a [SearchModel] from a Json object.
  factory SearchModel.fromJson(Map<String, dynamic> data) => SearchModel(
    topQuery: data['topQuery'] == null ? null : TopQueryModel.fromJson(data['topQuery'] as Map<String, dynamic>),
    songs: data['songs'] == null ? null : SongModel.fromJson(data['songs'] as Map<String, dynamic>),
    albums: data['albums'] == null ? null : AlbumModel.fromJson(data['albums'] as Map<String, dynamic>),
    artists: data['artists'] == null ? null : ArtistModel.fromJson(data['artists'] as Map<String, dynamic>),
    playlists: data['playlists'] == null ? null : PlaylistModel.fromJson(data['playlists'] as Map<String, dynamic>),
  );

  /// Top trending
  TopQueryModel? topQuery;

  /// List of Songs
  SongModel? songs;

  /// List of Albums
  AlbumModel? albums;

  /// List of Artists
  ArtistModel? artists;

  /// List of Playlists
  PlaylistModel? playlists;
}
