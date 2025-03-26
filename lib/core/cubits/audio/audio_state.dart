part of 'audio_cubit.dart';

/// [AudioCubit]'s state
@immutable
final class AudioState {
  /// Constructor
  const AudioState({
    this.playState = AudioPlayState.idle,
    this.song,
    this.songSources = const [],
    this.positioned = Duration.zero,
    this.duration = Duration.zero,
    this.isRepeat = false,
    this.isShuffle = false,
    this.originSongSources = const [],
  });

  /// [AudioPlayState] of the audio
  final AudioPlayState playState;

  /// Current song for play
  final DbSongModel? song;

  /// List of Songs for play song in loop
  final List<DbSongModel> songSources;

  /// current index of Playing song
  int get currentIndex => songSources.indexWhere((element) => element.id == song?.id);

  /// Current Playing song positioned in Duration
  final Duration positioned;

  /// Current Playing song duration
  final Duration duration;

  /// For is source is shuffled or not
  final bool isShuffle;

  /// For is source is repeat or not
  final bool isRepeat;

  /// List of Songs
  final List<DbSongModel> originSongSources;

  /// Copy with
  AudioState copyWith({
    AudioPlayState? playState,
    DbSongModel? song,
    List<DbSongModel>? songSources,
    Duration? positioned,
    Duration? duration,
    bool? isShuffle,
    bool? isRepeat,
    List<DbSongModel>? originSongSources,
  }) {
    return AudioState(
      playState: playState ?? this.playState,
      song: song ?? this.song,
      songSources: songSources ?? this.songSources,
      positioned: positioned ?? this.positioned,
      duration: duration ?? this.duration,
      isShuffle: isShuffle ?? this.isShuffle,
      isRepeat: isRepeat ?? this.isRepeat,
      originSongSources: originSongSources ?? this.originSongSources,
    );
  }
}
