part of 'source_handler.dart';

/// Handles retrieving search history songs.
class SearchHistorySourceHandler extends SourceHandler {
  @override
  SourceType get sourceType => SourceType.searchHistory;

  @override
  Future<SourceData> getDatabaseData() async {
    return SourceData(songs: AppDB.searchManager.searchedSongs, sourceType: SourceType.searchHistory);
  }
}
