/// Represents the different states an audio player can be in.
///
/// This enum is used to track the current state of audio playback,
/// providing information about whether the audio is idle, playing,
/// paused, or in the process of loading.
enum AudioPlayState {
  /// The audio player is in an idle state.
  ///
  /// This means no audio is currently loaded or being played, and the
  /// player is ready to start playing a new audio source.
  idle,

  /// The audio player is actively playing audio.
  ///
  /// This indicates that audio playback is in progress.
  play,

  /// The audio player is paused.
  ///
  /// Audio playback is temporarily halted, but the playback position
  /// is maintained, allowing for resuming playback from the same point.
  pause,

  /// The audio player is resuming playback.
  ///
  /// This indicates that the audio playback, which was previously paused,
  /// is now continuing from where it left off.
  resume,

  /// The audio player is currently loading an audio source.
  ///
  /// This state indicates that the player is in the process of preparing
  /// a new audio file or stream for playback.
  loading,

  /// The audio player has encountered an error.
  ///
  /// This state indicates that something went wrong during playback,
  /// such as a problem with the audio source or an unexpected
  /// interruption.
  error,
}

/// Extension on Audio Play State
extension ExtAudioPlayState on AudioPlayState {
  /// Check current state is Play or not
  bool get isPlay => this == AudioPlayState.play;

  /// Check current state is Paused or not
  bool get isPause => this == AudioPlayState.pause;
}
