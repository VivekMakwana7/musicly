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
    this.isRepeat = false,
    this.isShuffle = false,
    this.currentIndex = 1,
    this.isNextDisabled = false,
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
  final bool isRepeat;

  /// For check Next Button Disabled or not
  final bool isNextDisabled;

  /// Is Prev button disabled
  bool get isPrevDisabled => currentIndex == 0;

  /// Copy with
  AudioState copyWith({
    AudioPlayState? playState,
    DbSongModel? song,
    Duration? positioned,
    Duration? duration,
    bool? isShuffle,
    bool? isRepeat,
    int? currentIndex,
    bool? isNextDisabled,
  }) {
    return AudioState(
      playState: playState ?? this.playState,
      song: song ?? this.song,
      positioned: positioned ?? this.positioned,
      duration: duration ?? this.duration,
      isShuffle: isShuffle ?? this.isShuffle,
      isRepeat: isRepeat ?? this.isRepeat,
      currentIndex: currentIndex ?? this.currentIndex,
      isNextDisabled: isNextDisabled ?? this.isNextDisabled,
    );
  }
}
