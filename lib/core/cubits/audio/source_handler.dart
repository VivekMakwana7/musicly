import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/logger.dart';
import 'package:musicly/core/rest_utils/api_request.dart';
import 'package:musicly/repos/search_repository.dart';

/// Represents the origin or context from which songs are being played.
enum SourceType {
  /// Song played from the recent songs list on the home page.
  recentPlayed,

  /// Song played from the user's liked songs.
  liked,

  /// Song played from the search history.
  searchHistory,

  /// Song played from a playlist.
  playlist,

  /// Song played as a result of a general search.
  search,

  /// Song played from a search result for albums.
  searchAlbum,

  /// Song played from a search result for artists.
  searchArtist,

  /// Song played from a search result for playlists.
  searchPlaylist,
}

/// Data representing a collection of songs and their source.
class SourceData {
  /// Default constructor
  const SourceData({
    required this.songs,
    required this.sourceType,
    this.currentPage = 1,
    this.isPaginated = false,
    this.hasMoreData = true,
    this.query,
  });

  /// List of Songs
  final List<DbSongModel> songs;

  /// Type of Source
  final SourceType sourceType;

  /// Current Page
  final int currentPage;

  /// Is given source paginated or not
  final bool isPaginated;

  /// If has more than another api call
  final bool hasMoreData;

  /// For search data
  final String? query;

  /// Creates a new [SourceData] instance with modified properties.
  SourceData copyWith({
    List<DbSongModel>? songs,
    SourceType? sourceType,
    int? currentPage,
    bool? isPaginated,
    bool? hasMoreData,
    String? query,
  }) {
    return SourceData(
      songs: songs ?? this.songs,
      sourceType: sourceType ?? this.sourceType,
      currentPage: currentPage ?? this.currentPage,
      isPaginated: isPaginated ?? this.isPaginated,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      query: query ?? this.query,
    );
  }
}

/// Abstract interface for handlers that fetch song data from various sources.
abstract class SourceHandler {
  /// Retrieves song data from a specific source.
  Future<SourceData> getSourceData({int page = 1, String? query});

  /// The type of the data source handled by this instance.
  SourceType get sourceType;

  /// List of Sources
  static List<SourceHandler> sources = [
    RecentPlayedSourceHandler(),
    LikedSongsSourceHandler(),
    SearchHistorySourceHandler(),
    PlaylistSourceHandler(),
    SearchSourceHandler(),
    SearchAlbumSourceHandler(),
    SearchArtistSourceHandler(),
    SearchPlaylistSourceHandler(),
  ];
}

/// Handles retrieving recently played songs.
class RecentPlayedSourceHandler implements SourceHandler {
  @override
  SourceType get sourceType => SourceType.recentPlayed;

  @override
  Future<SourceData> getSourceData({int page = 1, int perPage = 20, String? query}) async {
    return SourceData(songs: Injector.instance<AppDB>().recentPlayedSong, sourceType: SourceType.recentPlayed);
  }
}

/// Handles retrieving liked songs.
class LikedSongsSourceHandler implements SourceHandler {
  @override
  SourceType get sourceType => SourceType.liked;

  @override
  Future<SourceData> getSourceData({int page = 1, int perPage = 10, String? query}) async {
    return SourceData(songs: Injector.instance<AppDB>().likedSongs, sourceType: SourceType.liked);
  }
}

/// Handles retrieving search history songs.
class SearchHistorySourceHandler implements SourceHandler {
  @override
  SourceType get sourceType => SourceType.searchHistory;

  @override
  Future<SourceData> getSourceData({int page = 1, int perPage = 10, String? query}) async {
    return SourceData(songs: Injector.instance<AppDB>().songSearchHistory, sourceType: SourceType.searchHistory);
  }
}

/// Handles retrieving songs from a playlist.
class PlaylistSourceHandler implements SourceHandler {
  @override
  SourceType get sourceType => SourceType.playlist;

  @override
  Future<SourceData> getSourceData({int page = 1, int perPage = 10, String? query}) async {
    return SourceData(songs: Injector.instance<AppDB>().songSearchHistory, sourceType: SourceType.searchHistory);
  }
}

/// Handles retrieving songs from a general search.
class SearchSourceHandler implements SourceHandler {
  final _searchRepo = Injector.instance<SearchRepository>();
  bool _hasMoreResult = true;

  @override
  SourceType get sourceType => SourceType.search;

  @override
  Future<SourceData> getSourceData({int page = 1, String? query}) async {
    final searchResult = await _fetchSearchSongsFromNetwork(page: page, query: query ?? '');
    '_hasMoreResult : $_hasMoreResult'.logD;
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

/// Handles retrieving songs from a search for albums.
class SearchAlbumSourceHandler implements SourceHandler {
  @override
  Future<SourceData> getSourceData({int page = 1, int perPage = 10, String? query}) async {
    return SourceData(songs: [], sourceType: sourceType, isPaginated: true, currentPage: page);
  }

  @override
  SourceType get sourceType => SourceType.searchAlbum;
}

/// Handles retrieving songs from a search for artists.
class SearchArtistSourceHandler implements SourceHandler {
  @override
  Future<SourceData> getSourceData({int page = 1, int perPage = 10, String? query}) async {
    return SourceData(songs: [], sourceType: sourceType, isPaginated: true, currentPage: page);
  }

  @override
  SourceType get sourceType => SourceType.searchArtist;
}

/// Handles retrieving songs from a search for playlists.
class SearchPlaylistSourceHandler implements SourceHandler {
  @override
  Future<SourceData> getSourceData({int page = 1, int perPage = 10, String? query}) async {
    return SourceData(songs: [], sourceType: sourceType, isPaginated: true, currentPage: page);
  }

  @override
  SourceType get sourceType => SourceType.searchPlaylist;
}
