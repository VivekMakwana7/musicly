part of 'playlist_detail_cubit.dart';

/// [PlaylistDetailCubit]'s state
@immutable
final class PlaylistDetailState {
  /// Playlist Detail State constructor
  const PlaylistDetailState({this.apiState = ApiState.idle, this.playlist});

  /// Playlist detail Current API state
  final ApiState apiState;

  /// Current Playlist details
  final DbPlaylistModel? playlist;

  /// Playlist Detail State copy with
  PlaylistDetailState copyWith({ApiState? apiState, DbPlaylistModel? playlist}) {
    return PlaylistDetailState(apiState: apiState ?? this.apiState, playlist: playlist ?? this.playlist);
  }
}
