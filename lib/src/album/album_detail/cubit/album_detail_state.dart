part of 'album_detail_cubit.dart';

/// [AlbumDetailCubit]'s state
@immutable
final class AlbumDetailState {
  /// Default constructor
  const AlbumDetailState({this.apiState = ApiState.idle, this.album});

  /// Album Detail API Current State
  final ApiState apiState;

  /// Album details
  final DbAlbumModel? album;

  /// Copy with
  AlbumDetailState copyWith({ApiState? apiState, DbAlbumModel? album}) {
    return AlbumDetailState(apiState: apiState ?? this.apiState, album: album ?? this.album);
  }
}
