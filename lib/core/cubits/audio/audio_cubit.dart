import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:musicly/core/cubits/audio/source_handler.dart';
import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/db/data_base_handler.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/enums/audio_play_state.dart';
import 'package:musicly/core/extensions/ext_string_alert.dart';
import 'package:musicly/core/logger.dart';

part 'audio_state.dart';

/// For Handle Audio Operation
class AudioCubit extends Cubit<AudioState> {
  /// Default constructor
  AudioCubit() : super(const AudioState()) {
    _initListeners();
  }

  /// Instance of AudioPlayer
  final AudioPlayer _audioPlayer = AudioPlayer();

  SourceData? _currentSource;

  @override
  Future<void> close() {
    _audioPlayer.dispose();
    return super.close();
  }

  void _addToRecentPlayed(DbSongModel song) {
    final recentPlayedSongs = Injector.instance<AppDB>().recentPlayedSong;
    if (recentPlayedSongs.any((element) => element.id == song.id)) {
      recentPlayedSongs.remove(song);
    }
    recentPlayedSongs.insert(0, song);
    Injector.instance<AppDB>().recentPlayedSong = recentPlayedSongs.toSet().toList();
  }

  void _initListeners() {
    _audioPlayer.onPlayerStateChanged.listen(_handlePlayerStateChange);
    _audioPlayer.onDurationChanged.listen((d) => emit(state.copyWith(duration: d)));
    _audioPlayer.onPositionChanged.listen((p) => emit(state.copyWith(positioned: p)));
  }

  void _handlePlayerStateChange(PlayerState playerState) {
    final playState = switch (playerState) {
      PlayerState.playing => AudioPlayState.play,
      PlayerState.paused => AudioPlayState.pause,
      PlayerState.stopped => AudioPlayState.idle,
      PlayerState.completed => _handlePlaybackComplete(),
      PlayerState.disposed => AudioPlayState.idle,
    };

    emit(state.copyWith(playState: playState, song: playState == AudioPlayState.idle ? null : state.song));
  }

  AudioPlayState _handlePlaybackComplete() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      playNextSong();
    });
    return AudioPlayState.idle;
  }

  Future<void> _playSong() async {
    final song = state.song;
    if (song == null || (song.downloadUrl?.isEmpty ?? true)) {
      'Please select a valid song'.showErrorAlert();
      emit(state.copyWith(playState: AudioPlayState.error));
      return;
    }

    final url = song.downloadUrl!.last.url;
    _checkLike();
    'Playing: ${song.name} | ${song.id} | Duration: ${song.duration}'.logD;

    try {
      await _audioPlayer.setSourceUrl(url);
      await _audioPlayer.play(_audioPlayer.source!);
    } on Object catch (e) {
      'Playback error: $e'.logE;
      'Playback failed. Please try again'.showErrorAlert();
      emit(state.copyWith(playState: AudioPlayState.error));
    }
  }

  /// For toggle Play Pause
  Future<void> togglePlayPause() async {
    if (state.playState == AudioPlayState.play) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
  }

  /// For seek to given positioned
  Future<void> seekToPosition(double positioned, double maxPositioned) async {
    final positionedInMilliSeconds = (positioned * state.duration.inMilliseconds) / maxPositioned;
    await _audioPlayer.seek(Duration(milliseconds: positionedInMilliSeconds.toInt()));
  }

  /// Play Next Song
  Future<void> playNextSong() async {
    if (_currentSource != null) {
      await _loadMoreData();
      final currentIndex = _currentSource!.songs.indexOf(state.song!);
      if (currentIndex == _currentSource!.songs.length - 1 && state.isRepeat) {
        _setSource(0);
        return;
      }
      if (currentIndex < _currentSource!.songs.length - 1) {
        final nextIndex = currentIndex + 1;
        _setSource(nextIndex);
      } else {
        'User played all song'.logD;
        await _audioPlayer.stop();
      }
    } else {
      'Source not found'.logE;
    }
  }

  /// Play Previous Song
  void playPreviousSong() {
    if (_currentSource != null) {
      final index = _currentSource!.songs.indexOf(state.song!);
      if (index > 0) {
        _setSource(index - 1);
      }
    } else {
      'Source not found'.logE;
    }
  }

  /// Toggle Like Song
  void toggleLikeSong({bool? isLiked}) {
    if (_currentSource != null) {
      final song = state.song?.copyWith(isLiked: isLiked ?? !(state.song?.isLiked ?? false));
      final sourceList = _currentSource!.songs.toList();
      sourceList[sourceList.indexOf(state.song!)] = song!;
      emit(state.copyWith(song: song));
      if (isLiked == null) DatabaseHandler.toggleLikedSong(song);
    } else {
      'Source not found'.logE;
    }
  }

  /// Toggle Repeat Song
  void toggleRepeatSong() {
    emit(state.copyWith(isRepeat: !state.isRepeat));
  }

  /// Toggle Shuffle Song
  void toggleShuffleSong() {
    // if (!state.isShuffle) {
    //   final list =
    //       state.songSources.toList()
    //         ..removeWhere((element) => element.id == state.song?.id)
    //         ..insert(0, state.song!)
    //         ..shuffle();
    //   emit(state.copyWith(isShuffle: !state.isShuffle, songSources: list));
    // } else {
    //   final list = state.originSongSources.toList();
    //   emit(state.copyWith(isShuffle: !state.isShuffle, songSources: list));
    // }
  }

  /// For check Like
  void _checkLike() {
    final isLiked = DatabaseHandler.isSongLiked(state.song!);
    toggleLikeSong(isLiked: isLiked);
  }

  /// Load source data by SourceType
  Future<void> loadSourceData({required SourceType type, required String songId, String? query, int page = 1}) async {
    emit(state.copyWith(playState: AudioPlayState.loading));
    final handler = SourceHandler.sources.firstWhere((h) => h.sourceType == type);
    _currentSource = await handler.getSourceData(query: query, page: page);
    if (_currentSource != null) {
      final songIndex = _currentSource!.songs.indexWhere((element) => element.id == songId);
      _setSource(songIndex, isFromLoadSource: true);
    } else {
      'Source not found'.logE;
      'Source not found'.showErrorAlert();
    }
  }

  void _setSource(int index, {bool isFromLoadSource = false}) {
    final song = _currentSource!.songs[index];
    emit(state.copyWith(song: song, currentIndex: index, isNextDisabled: _checkNextButtonDisabledOrNot()));
    _playSong();
    _addToRecentPlayed(song);
    if (isFromLoadSource) _addSearchHistory(song);
  }

  bool _checkNextButtonDisabledOrNot() {
    if (_currentSource != null) {
      return state.currentIndex == _currentSource!.songs.length - 1 && !state.isRepeat;
    }
    return false;
  }

  Future<void> _loadMoreData() async {
    if (_currentSource != null &&
        _currentSource!.isPaginated &&
        (_currentSource!.songs.length - state.currentIndex < 3)) {
      final handler = SourceHandler.sources.firstWhere((h) => h.sourceType == _currentSource!.sourceType);
      final newData = await handler.getSourceData(page: _currentSource!.currentPage + 1, query: _currentSource!.query);
      _currentSource = _currentSource!.copyWith(
        songs: [..._currentSource!.songs, ...newData.songs],
        currentPage: newData.currentPage,
        hasMoreData: newData.hasMoreData,
      );
    }
  }

  void _addSearchHistory(DbSongModel song) {
    if (_currentSource != null && _currentSource!.sourceType == SourceType.search) {
      DatabaseHandler.addToSongSearchHistory(song);
    }
  }
}
