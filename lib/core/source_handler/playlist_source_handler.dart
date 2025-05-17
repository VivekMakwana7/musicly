part of 'source_handler.dart';

/// Handles retrieving songs from a playlist.
class PlaylistSourceHandler extends SourceHandler {
  @override
  SourceType get sourceType => SourceType.playlist;

  @override
  Future<SourceData> getDatabaseData() async {
    return SourceData(songs: AppDB.searchManager.searchedSongs, sourceType: SourceType.searchHistory);
  }
}
