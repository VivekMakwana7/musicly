import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicly/core/cubits/audio/audio_cubit.dart';
import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/di/injector.dart';

/// My Audio Handler
// Media Notification Setup
Future<MyAudioHandler> initAudioService() async {
  return AudioService.init(
    builder: MyAudioHandler.new,
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.musicly.musicly',
      androidNotificationChannelName: 'Music playback',
      androidNotificationOngoing: true,
    ),
  );
}

/// My Audio Handler
class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  /// Instance of Audio Player
  AudioPlayer player = Injector.instance<AudioPlayer>();

  final ConcatenatingAudioSource _playlist = ConcatenatingAudioSource(
    children: [],
    useLazyPreparation: AppDB.settingManager.gapLess,
  );

  /// Function to Create an audio source from MediaItem
  UriAudioSource _createAudioSource(MediaItem mediaItem) {
    return ProgressiveAudioSource(Uri.parse(mediaItem.id));
  }

  /// Function to Create an audio source from Download MediaItem
  UriAudioSource _createAudioSourceDownload(MediaItem mediaItem) {
    return AudioSource.file(mediaItem.id);
  }

  /// Listen for changes in current song index and update the media item
  void _listenForCurrentSongIndexChanges() {
    player.currentIndexStream.listen((index) {
      final playlist = queue.value;
      if (index == null || playlist.isEmpty) return;
      mediaItem.add(playlist[index]);

      // Pass index to Audio Cubit
      Injector.instance<AudioCubit>().playingSongAtIndex(index);
    });
  }

  /// Broadcast the current playback state based on received PlaybackState
  void _broadcastState(PlaybackEvent event) {
    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          if (player.hasPrevious) MediaControl.skipToPrevious,
          if (player.playing) MediaControl.pause else MediaControl.play,
          if (player.hasNext) MediaControl.skipToNext,
        ],
        systemActions: {MediaAction.seek, MediaAction.seekBackward, MediaAction.seekForward},
        processingState:
            const {
              ProcessingState.idle: AudioProcessingState.idle,
              ProcessingState.loading: AudioProcessingState.loading,
              ProcessingState.buffering: AudioProcessingState.buffering,
              ProcessingState.completed: AudioProcessingState.completed,
              ProcessingState.ready: AudioProcessingState.ready,
            }[player.processingState]!,
        playing: player.playing,
        updatePosition: player.position,
        bufferedPosition: player.bufferedPosition,
        queueIndex: event.currentIndex,
      ),
    );
  }

  /// Function to initialize the songs and set up the audio Player
  Future<void> initSongs(List<MediaItem> songs, {required int index, bool isFromDownload = false}) async {
    // Clear the playlist & Queue if it exists
    queue.value.clear();
    await _playlist.clear();
    // Listen for playback evens and broadcast the state
    player.playbackEventStream.listen(_broadcastState);

    // create a list of audio sources from provided songs
    final sources =
        isFromDownload ? songs.map(_createAudioSourceDownload).toList() : songs.map(_createAudioSource).toList();

    // Add source to playlist
    await _playlist.addAll(sources);

    // set the audio source of the audio player to the Concatenating of the audio source
    await player.setAudioSource(_playlist, initialIndex: index);

    // Add the songs to queues
    final newQueue = queue.value..addAll(songs);
    queue.add(newQueue);

    // Listen for changes in Current Index
    _listenForCurrentSongIndexChanges();

    // Listen for processing state changes and skip to next song when completed
    player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        skipToNext();
      }
    });

    // Listen for Player state changes
    _listenPlayerState();

    // Listen for Player song position changes
    _listenPositionChanges();

    // Listen for Player song duration changes
    _listenDurationChanges();

    // Listen for shuffle changes
    _listenShuffleChanges();

    // Set player to the index if provided
    if (index < songs.length) {
      await skipToQueueItem(index);
    }
  }

  // Play function for start Playback
  @override
  Future<void> play() async {
    await player.play();
  }

  // Pause function for pause Playback
  @override
  Future<void> pause() async {
    await player.pause();
  }

  // Seek function to change the playback position
  @override
  Future<void> seek(Duration position) async {
    await player.seek(position);
  }

  // Skip to Specific item in the queue and start playback
  @override
  Future<void> skipToQueueItem(int index) async {
    await player.seek(Duration.zero, index: index);
    await player.play();
  }

  // Skip to next song in the queue
  @override
  Future<void> skipToNext() async {
    await player.seekToNext();
  }

  // Skip to previous song in the queue
  @override
  Future<void> skipToPrevious() async {
    await player.seekToPrevious();
  }

  // Listen Play state and Pass it to Audio Cubit
  void _listenPlayerState() {
    player.playerStateStream.listen((event) {
      Injector.instance<AudioCubit>().handlePlayerStateChange(event);
    });
  }

  // Listen Position changes and pass it to audio cubit
  void _listenPositionChanges() {
    player.positionStream.listen((position) {
      Injector.instance<AudioCubit>().handlePositionChange(position);
    });
  }

  // Listen Duration changes and pass it to audio cubit
  void _listenDurationChanges() {
    player.durationStream.listen((duration) {
      Injector.instance<AudioCubit>().handleDurationChange(duration);
    });
  }

  // Listen for shuffle changes
  void _listenShuffleChanges() {
    player.shuffleModeEnabledStream.listen((shuffleMode) {
      Injector.instance<AudioCubit>().handleShuffleModeChange(isShuffle: shuffleMode);
    });
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    await player.setShuffleModeEnabled(shuffleMode == AudioServiceShuffleMode.none);
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    // create a list of audio sources from provided songs
    final sources = mediaItems.map(_createAudioSource).toList();
    // Append new source to existing one
    await _playlist.addAll(sources);
    // Append new queue to existing one
    final newQueue = queue.value..addAll(mediaItems);
    queue.add(newQueue);
  }
}
