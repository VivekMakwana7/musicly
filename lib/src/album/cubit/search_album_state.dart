part of 'search_album_cubit.dart';

/// [SearchAlbumCubit]'s state
@immutable
final class SearchAlbumState {
  /// Default constructor
  const SearchAlbumState({this.apiState = ApiState.idle, this.albums = const []});

  /// Search Album API Current State
  final ApiState apiState;

  /// List of albums
  final List<DbAlbumModel> albums;

  /// Copy with
  SearchAlbumState copyWith({ApiState? apiState, List<DbAlbumModel>? albums}) {
    return SearchAlbumState(apiState: apiState ?? this.apiState, albums: albums ?? this.albums);
  }
}
