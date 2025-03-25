part of 'search_artist_cubit.dart';

/// [SearchArtistCubit]'s state
@immutable
final class SearchArtistState {
  /// Default constructor
  const SearchArtistState({this.apiState = ApiState.idle, this.artists = const []});

  /// The current state of the API call
  final ApiState apiState;

  /// List of artists
  final List<DbArtistModel> artists;

  /// Copy With
  SearchArtistState copyWith({ApiState? apiState, List<DbArtistModel>? artists}) {
    return SearchArtistState(apiState: apiState ?? this.apiState, artists: artists ?? this.artists);
  }
}
