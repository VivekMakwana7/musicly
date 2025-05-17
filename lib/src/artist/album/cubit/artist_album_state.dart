part of 'artist_album_cubit.dart';

/// [ArtistAlbumCubit]'s state
@immutable
final class ArtistAlbumState {
  /// Artist Album State constructor
  const ArtistAlbumState({this.albums = const [], this.apiState = ApiState.idle});

  /// List of albums
  final List<DbAlbumModel> albums;

  /// API state
  final ApiState apiState;

  /// Copy Artist Album State
  ArtistAlbumState copyWith({List<DbAlbumModel>? albums, ApiState? apiState}) {
    return ArtistAlbumState(albums: albums ?? this.albums, apiState: apiState ?? this.apiState);
  }
}
