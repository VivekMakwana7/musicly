import 'package:musicly/core/rest_utils/api_request.dart';
import 'package:musicly/core/rest_utils/endpoints.dart';
import 'package:musicly/src/search/model/global_search_model.dart';
import 'package:pkg_dio/pkg_dio.dart';

/// Repository for search related operations
class SearchRepository {
  /// Constructor
  SearchRepository({required this.dio});

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
}
