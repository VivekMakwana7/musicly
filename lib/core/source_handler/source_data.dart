part of 'source_handler.dart';

/// Data representing a collection of songs and their source.
class SourceData {
  /// Default constructor
  const SourceData({
    required this.songs,
    required this.sourceType,
    this.currentPage = 0,
    this.isPaginated = false,
    this.hasMoreData = true,
    this.query,
    this.albumId,
    this.artistId,
    this.playlistId,
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

  /// For album id
  final String? albumId;

  /// For artist id
  final String? artistId;

  /// For playlist id
  final String? playlistId;

  /// Creates a new [SourceData] instance with modified properties.
  SourceData copyWith({
    List<DbSongModel>? songs,
    SourceType? sourceType,
    int? currentPage,
    bool? isPaginated,
    bool? hasMoreData,
    String? query,
    String? albumId,
    String? artistId,
    String? playlistId,
  }) {
    return SourceData(
      songs: songs ?? this.songs,
      sourceType: sourceType ?? this.sourceType,
      currentPage: currentPage ?? this.currentPage,
      isPaginated: isPaginated ?? this.isPaginated,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      query: query ?? this.query,
      albumId: albumId ?? this.albumId,
      artistId: artistId ?? this.artistId,
      playlistId: playlistId ?? this.playlistId,
    );
  }
}
