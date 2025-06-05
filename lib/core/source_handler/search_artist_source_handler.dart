part of 'source_handler.dart';

/// Handles retrieving songs from a search for artists.
class SearchArtistSourceHandler extends SourceHandler {
  final MusicRepo _searchRepo = Injector.instance<MusicRepo>();
  bool _hasMoreResult = true;

  @override
  SourceType get sourceType => SourceType.searchArtist;

  @override
  Future<SourceData> getArtistSongData({
    required String artistId,
    int page = 1,
  }) async {
    final songs = await _fetchSearchSongsFromNetwork(
      page: page,
      artistId: artistId,
    );
    'Artist songs : ${songs.map((e) => e.id).toList()}'.logD;
    return SourceData(
      songs: songs,
      sourceType: sourceType,
      isPaginated: true,
      currentPage: page,
    );
  }

  Future<List<DbSongModel>> _fetchSearchSongsFromNetwork({
    required int page,
    required String artistId,
  }) async {
    if (_hasMoreResult) {
      var songs = <DbSongModel>[];
      final param = {'page': page, 'sortBy': 'popularity', 'sortOrder': 'asc'};
      final res = await _searchRepo.getArtistSong(
        artistId,
        ApiRequest(params: param),
      );
      res.when(
        success: (data) {
          _hasMoreResult = data.songs?.isNotEmpty ?? false;
          songs = data.songs ?? [];
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
