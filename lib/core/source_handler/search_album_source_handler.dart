part of 'source_handler.dart';

/// Handles retrieving songs from a search for albums.
class SearchAlbumSourceHandler extends SourceHandler {
  @override
  SourceType get sourceType => SourceType.searchAlbum;

  @override
  Future<SourceData> getAlbumSongData({required String albumId, int page = 1}) {
    return Future.value(SourceData(songs: [], sourceType: sourceType));
  }
}
