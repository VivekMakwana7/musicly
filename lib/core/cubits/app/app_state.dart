part of 'app_cubit.dart';

/// AppState
@immutable
sealed class AppState {}

///
final class AppInitial extends AppState {}

/// State for Artist song Play
final class ArtistSongPlay extends AppState {
  /// Constructor
  ArtistSongPlay({required this.artistId});

  /// For navigate to particular Artist Id
  final String artistId;
}

/// State for Album song play
final class AlbumSongPlay extends AppState {
  /// Constructor
  AlbumSongPlay({required this.albumId});

  /// For navigate to particular Album id
  final String albumId;
}

/// State for Playlist song play
final class PlaylistSongPlay extends AppState {
  /// Constructor
  PlaylistSongPlay({required this.playlistId});

  /// For navigate to particular Playlist id
  final String playlistId;
}

/// For reset App state
final class AppResetState extends AppState {}
