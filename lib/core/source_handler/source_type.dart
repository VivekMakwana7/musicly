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

  /// Song played from a downloaded song.
  downloaded,
}
