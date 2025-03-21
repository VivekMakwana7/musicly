part of 'audio_cubit.dart';

/// [AudioCubit]'s state
@immutable
final class AudioState {
  /// Constructor
  const AudioState({this.playState = AudioPlayState.idle, this.song, this.songSources = const []});

  /// [AudioPlayState] of the audio
  final AudioPlayState playState;

  /// Current song for play
  final DbSongModel? song;

  /// List of Songs for play song in loop
  final List<DbSongModel> songSources;

  /// Copy with
  AudioState copyWith({AudioPlayState? playState, DbSongModel? song, List<DbSongModel>? songSources}) {
    return AudioState(
      playState: playState ?? this.playState,
      song: song ?? this.song,
      songSources: songSources ?? this.songSources,
    );
  }
}
