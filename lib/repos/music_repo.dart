import 'package:musicly/core/db/models/album/db_album_model.dart';
import 'package:musicly/core/db/models/artist/db_artist_model.dart';
import 'package:musicly/core/db/models/playlist/db_playlist_model.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';
import 'package:musicly/core/rest_utils/api_request.dart';
import 'package:musicly/core/rest_utils/endpoints.dart';
import 'package:musicly/src/album/models/search_album_response_model.dart';
import 'package:musicly/src/artist/models/search_artist_response_model.dart';
import 'package:musicly/src/artist/song/models/artist_album_model.dart';
import 'package:musicly/src/artist/song/models/artist_song_model.dart';
import 'package:musicly/src/search/model/global_search_model.dart';
import 'package:musicly/src/search_playlist/models/search_playlist_response_model.dart';
import 'package:musicly/src/song/models/search_song_response_model.dart';
import 'package:pkg_dio/pkg_dio.dart';

/// Repository for search related operations
class MusicRepo {
  /// Constructor
  MusicRepo({required this.dio});

  /// Dio instance
  final Dio dio;

  /// API call to search songs, albums, artists
  Future<ApiResult<GlobalSearchModel>> search(ApiRequest request) {
    return DioRequest<GlobalSearchModel>(
      dio: dio,
      path: EndPoints.search,
      jsonMapper: GlobalSearchModel.fromJson,
      cancelToken: request.cancelToken,
      hideKeyboard: request.hideKeyboard,
      data: request.data,
      options: request.options,
      params: request.params,
      receiveProgress: request.receiveProgress,
    ).get();
  }

  /// API call for Search Song By Id
  Future<ApiResult<List<DbSongModel>>> searchSongById(ApiRequest request) {
    return DioRequest<List<DbSongModel>>(
      dio: dio,
      path: EndPoints.searchSongById,
      listJsonMapper: DbSongModel.fromJsonList,
      cancelToken: request.cancelToken,
      hideKeyboard: request.hideKeyboard,
      options: request.options,
      params: request.params,
      receiveProgress: request.receiveProgress,
      pathParameter: request.pathParameter,
    ).get();
  }

  /// API call for Search Album By Id
  Future<ApiResult<DbAlbumModel>> searchAlbumById(ApiRequest request) {
    return DioRequest<DbAlbumModel>(
      dio: dio,
      path: EndPoints.searchAlbumById,
      jsonMapper: DbAlbumModel.fromJson,
      cancelToken: request.cancelToken,
      hideKeyboard: request.hideKeyboard,
      options: request.options,
      params: request.params,
      receiveProgress: request.receiveProgress,
      pathParameter: request.pathParameter,
    ).get();
  }

  /// API call for Search Artist By Id
  Future<ApiResult<DbArtistModel>> searchArtistById(ApiRequest request) {
    return DioRequest<DbArtistModel>(
      dio: dio,
      path: EndPoints.searchArtistById,
      jsonMapper: DbArtistModel.fromJson,
      cancelToken: request.cancelToken,
      hideKeyboard: request.hideKeyboard,
      options: request.options,
      params: request.params,
      receiveProgress: request.receiveProgress,
      pathParameter: request.pathParameter,
    ).get();
  }

  /// API call for Search Playlist By Id
  Future<ApiResult<DbPlaylistModel>> searchPlaylistById(ApiRequest request) {
    return DioRequest<DbPlaylistModel>(
      dio: dio,
      path: EndPoints.searchPlaylistById,
      jsonMapper: DbPlaylistModel.fromJson,
      cancelToken: request.cancelToken,
      hideKeyboard: request.hideKeyboard,
      options: request.options,
      params: request.params,
      receiveProgress: request.receiveProgress,
      pathParameter: request.pathParameter,
    ).get();
  }

  /// API call for Search Song By Query
  Future<ApiResult<SearchSongResponseModel>> searchSongByQuery(ApiRequest request) {
    return DioRequest<SearchSongResponseModel>(
      dio: dio,
      path: EndPoints.searchSongByQuery,
      jsonMapper: SearchSongResponseModel.fromJson,
      cancelToken: request.cancelToken,
      hideKeyboard: request.hideKeyboard,
      options: request.options,
      params: request.params,
      receiveProgress: request.receiveProgress,
      pathParameter: request.pathParameter,
    ).get();
  }

  /// API call for Search Album By Query
  Future<ApiResult<SearchAlbumResponseModel>> searchAlbumByQuery(ApiRequest request) {
    return DioRequest<SearchAlbumResponseModel>(
      dio: dio,
      path: EndPoints.searchAlbumByQuery,
      jsonMapper: SearchAlbumResponseModel.fromJson,
      cancelToken: request.cancelToken,
      hideKeyboard: request.hideKeyboard,
      options: request.options,
      params: request.params,
      receiveProgress: request.receiveProgress,
      pathParameter: request.pathParameter,
    ).get();
  }

  /// API call for Search Artist By Query
  Future<ApiResult<SearchArtistResponseModel>> searchArtistByQuery(ApiRequest request) {
    return DioRequest<SearchArtistResponseModel>(
      dio: dio,
      path: EndPoints.searchArtistByQuery,
      jsonMapper: SearchArtistResponseModel.fromJson,
      cancelToken: request.cancelToken,
      hideKeyboard: request.hideKeyboard,
      options: request.options,
      params: request.params,
      receiveProgress: request.receiveProgress,
      pathParameter: request.pathParameter,
    ).get();
  }

  /// API call for Search Playlist By Query
  Future<ApiResult<SearchPlaylistResponseModel>> searchPlaylistByQuery(ApiRequest request) {
    return DioRequest<SearchPlaylistResponseModel>(
      dio: dio,
      path: EndPoints.searchPlaylistByQuery,
      jsonMapper: SearchPlaylistResponseModel.fromJson,
      cancelToken: request.cancelToken,
      hideKeyboard: request.hideKeyboard,
      options: request.options,
      params: request.params,
      receiveProgress: request.receiveProgress,
      pathParameter: request.pathParameter,
    ).get();
  }

  /// API call for Get Artist Song
  Future<ApiResult<ArtistSongModel>> getArtistSong(String id, ApiRequest request) {
    return DioRequest<ArtistSongModel>(
      dio: dio,
      path: EndPoints.artistSongs(id),
      jsonMapper: ArtistSongModel.fromJson,
      cancelToken: request.cancelToken,
      hideKeyboard: request.hideKeyboard,
      options: request.options,
      params: request.params,
      receiveProgress: request.receiveProgress,
      pathParameter: request.pathParameter,
    ).get();
  }

  /// API call for Get Artist Album
  Future<ApiResult<ArtistAlbumModel>> getArtistAlbum(String id, ApiRequest request) {
    return DioRequest<ArtistAlbumModel>(
      dio: dio,
      path: EndPoints.artistAlbums(id),
      jsonMapper: ArtistAlbumModel.fromJson,
      cancelToken: request.cancelToken,
      hideKeyboard: request.hideKeyboard,
      options: request.options,
      params: request.params,
      receiveProgress: request.receiveProgress,
      pathParameter: request.pathParameter,
    ).get();
  }
}
