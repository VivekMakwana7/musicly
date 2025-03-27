part of 'artist_song_cubit.dart';

/// [ArtistSongCubit]'s state
@immutable
final class ArtistSongState {
  /// Artist Song State constructor
  const ArtistSongState({this.apiState = ApiState.idle, this.songs = const []});

  /// Current API State
  final ApiState apiState;

  /// List of Songs
  final List<DbSongModel> songs;

  /// Copy with
  ArtistSongState copyWith({ApiState? apiState, List<DbSongModel>? songs}) {
    return ArtistSongState(apiState: apiState ?? this.apiState, songs: songs ?? this.songs);
  }
}
