part of 'source_handler.dart';

/// Handles retrieving recently played songs.
class RecentPlayedSourceHandler extends SourceHandler {
  @override
  SourceType get sourceType => SourceType.recentPlayed;

  @override
  Future<SourceData> getDatabaseData() async {
    return SourceData(songs: AppDB.homeManager.recentPlayedSongs, sourceType: SourceType.recentPlayed);
  }
}
