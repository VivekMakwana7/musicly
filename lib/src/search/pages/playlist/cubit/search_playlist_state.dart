part of 'search_playlist_cubit.dart';

/// Search Playlist cubit's state
@immutable
final class SearchPlaylistState {
  /// Search Playlist State Constructor
  const SearchPlaylistState({this.apiState = ApiState.idle, this.playlists = const []});

  /// Current API state
  final ApiState apiState;

  /// List of playlists
  final List<DbPlaylistModel> playlists;

  /// Copy with
  SearchPlaylistState copyWith({ApiState? apiState, List<DbPlaylistModel>? playlists}) {
    return SearchPlaylistState(apiState: apiState ?? this.apiState, playlists: playlists ?? this.playlists);
  }
}
