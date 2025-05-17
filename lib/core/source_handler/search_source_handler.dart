part of 'source_handler.dart';

/// Handles retrieving songs from a general search.
class SearchSourceHandler extends SourceHandler {
  final _searchRepo = Injector.instance<MusicRepo>();
  bool _hasMoreResult = true;

  @override
  SourceType get sourceType => SourceType.search;

  @override
  Future<SourceData> getSearchSongData({int page = 1, String? query}) async {
    final searchResult = await _fetchSearchSongsFromNetwork(page: page, query: query ?? '');
    'searchResult : ${searchResult.length}'.logD;
    return SourceData(
      songs: searchResult,
      sourceType: sourceType,
      isPaginated: true,
      currentPage: page,
      hasMoreData: _hasMoreResult,
      query: query,
    );
  }

  Future<List<DbSongModel>> _fetchSearchSongsFromNetwork({required int page, required String query}) async {
    if (_hasMoreResult) {
      var songs = <DbSongModel>[];
      final param = {'query': query, 'page': page, 'limit': 10};
      'param : $param'.logD;
      final res = await _searchRepo.searchSongByQuery(ApiRequest(params: param));
      res.when(
        success: (data) {
          _hasMoreResult = data.results?.isNotEmpty ?? false;
          songs = data.results ?? [];
        },
        error: (exception) {
          'Search song by Query API failed : $exception'.logE;
        },
      );

      return songs;
    } else {
      return [];
    }
  }
}
