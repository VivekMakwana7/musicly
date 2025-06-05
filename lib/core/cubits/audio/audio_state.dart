part of 'audio_cubit.dart';

/// [AudioCubit]'s state
@immutable
final class AudioState {
  /// Constructor
  const AudioState({
    this.playState = AudioPlayState.idle,
    this.song,
    this.positioned = Duration.zero,
    this.duration = Duration.zero,
    this.loopMode = LoopMode.off,
    this.isShuffle = false,
    this.currentIndex = 1,
    this.isNextDisabled = false,
    this.currentSource,
  });

  /// [AudioPlayState] of the audio
  final AudioPlayState playState;

  /// Current song for play
  final DbSongModel? song;

  /// current index of Playing song
  final int currentIndex;

  /// Current Playing song positioned in Duration
  final Duration positioned;

  /// Current Playing song duration
  final Duration duration;

  /// For is source is shuffled or not
  final bool isShuffle;

  /// For is source is repeat or not
  final LoopMode loopMode;

  /// For check Next Button Disabled or not
  final bool isNextDisabled;

  /// Current source data for audio player
  final SourceData? currentSource;

  /// Is Prev button disabled
  bool get isPrevDisabled => currentIndex == 0;

  /// Copy with
  AudioState copyWith({
    AudioPlayState? playState,
    DbSongModel? song,
    Duration? positioned,
    Duration? duration,
    bool? isShuffle,
    int? currentIndex,
    bool? isNextDisabled,
    LoopMode? loopMode,
    SourceData? currentSource,
  }) {
    return AudioState(
      playState: playState ?? this.playState,
      song: song ?? this.song,
      positioned: positioned ?? this.positioned,
      duration: duration ?? this.duration,
      isShuffle: isShuffle ?? this.isShuffle,
      currentIndex: currentIndex ?? this.currentIndex,
      isNextDisabled: isNextDisabled ?? this.isNextDisabled,
      loopMode: loopMode ?? this.loopMode,
      currentSource: currentSource ?? this.currentSource,
    );
  }
}
