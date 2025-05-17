part of 'source_handler.dart';

/// Handles retrieving Downloaded songs.
class DownloadedSongsSourceHandler extends SourceHandler {
  @override
  SourceType get sourceType => SourceType.downloaded;

  @override
  Future<SourceData> getDatabaseData() async {
    return SourceData(songs: AppDB.downloadManager.downloadedSongs, sourceType: SourceType.downloaded);
  }
}
