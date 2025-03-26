part of 'app_cubit.dart';

/// AppState
@immutable
sealed class AppState {}

///
final class AppInitial extends AppState {}

/// State for Artist song Play
final class ArtistSongPlay extends AppState{
  /// Constructor
  ArtistSongPlay({required this.artistId});

  /// For navigate to particular Artist Id
  final String artistId;
}
