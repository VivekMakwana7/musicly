part of 'artist_detail_cubit.dart';

/// [ArtistDetailCubit]'s state
@immutable
final class ArtistDetailState {
  /// Artist Detail State constructor
  const ArtistDetailState({this.apiState = ApiState.idle, this.artist});

  /// Artist detail API state
  final ApiState apiState;

  /// Current Artist details
  final DbArtistModel? artist;

  /// copy with
  ArtistDetailState copyWith({ApiState? apiState, DbArtistModel? artist}) {
    return ArtistDetailState(apiState: apiState ?? this.apiState, artist: artist ?? this.artist);
  }
}
