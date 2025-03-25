part of 'search_song_cubit.dart';

/// [SearchSongCubit]'s state
@immutable
final class SearchSongState {
  /// [SearchSongCubit]'s state constructor
  const SearchSongState({this.apiState = ApiState.idle, this.songs = const []});

  /// Search Song API's current state
  final ApiState apiState;

  /// List of Songs
  final List<DbSongModel> songs;

  /// Copy with
  SearchSongState copyWith({ApiState? apiState, List<DbSongModel>? songs}) {
    return SearchSongState(apiState: apiState ?? this.apiState, songs: songs ?? this.songs);
  }
}
