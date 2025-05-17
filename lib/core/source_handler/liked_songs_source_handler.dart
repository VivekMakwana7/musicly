part of 'source_handler.dart';

/// Handles retrieving liked songs.
class LikedSongsSourceHandler extends SourceHandler {
  @override
  SourceType get sourceType => SourceType.liked;

  @override
  Future<SourceData> getDatabaseData() async {
    return SourceData(songs: AppDB.likedManager.likedSongs, sourceType: SourceType.liked);
  }
}
