part of 'source_handler.dart';

/// Handles retrieving songs from a search for playlists.
class SearchPlaylistSourceHandler extends SourceHandler {
  @override
  SourceType get sourceType => SourceType.searchPlaylist;
}
