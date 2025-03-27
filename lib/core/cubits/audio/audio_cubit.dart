import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/db/data_base_handler.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/enums/audio_play_state.dart';
import 'package:musicly/core/extensions/ext_string_alert.dart';
import 'package:musicly/core/logger.dart';
import 'package:musicly/core/rest_utils/api_request.dart';
import 'package:musicly/repos/search_repository.dart';

part 'audio_state.dart';

/// For Handle Audio Operation
class AudioCubit extends Cubit<AudioState> {
  /// Default constructor
  AudioCubit() : super(const AudioState()) {
    _initListeners();
  }

  /// Instance of AudioPlayer
  final AudioPlayer _audioPlayer = AudioPlayer();
  final _searchRepo = Injector.instance<SearchRepository>();

  /// For check whether has more data
  bool hasMoreSearchResults = false;
  SourceType? _type;
  int _page = 1;
  String? _query;

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

  Future<void> _searchSongs({required String query, required int page, String? songId}) async {
    final param = {'query': query, 'page': page, 'limit': 10};
    'param : $param'.logD;
    final res = await _searchRepo.searchSongByQuery(ApiRequest(params: param));
    res.when(
      success: (data) {
        hasMoreSearchResults = data.results?.isNotEmpty ?? false;
        emit(
          state.copyWith(
            songSources: [...state.songSources, ...?data.results],
            originSongSources: [...state.originSongSources, ...?data.results],
          ),
        );
        if (songId != null) {
          final song = data.results?.firstWhere((element) => element.id == songId);
          if (song != null) {
            _setSource(song: song, songSource: data.results ?? []);
            DatabaseHandler.addToSongSearchHistory(song);
          }
        }
      },
      error: (exception) {
        'Search song by Query API failed : $exception'.logE;
        exception.message.showErrorAlert();
        emit(state.copyWith(playState: AudioPlayState.error));
      },
    );
  }

  void _setSource({required DbSongModel song, required List<DbSongModel> songSource}) {
    'Network source ${songSource.map((e) => e.id).toList()}'.logD;
    emit(
      state.copyWith(
        song: song,
        songSources: songSource,
        originSongSources: songSource,
        playState: AudioPlayState.loading,
      ),
    );
    _playSong();
    _addToRecentPlayed(song);
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
      if (_type == null) {
        _playLocalNext();
      } else {
        _playNetworkNext();
      }
    });
    return AudioPlayState.idle;
  }

  void _playLocalNext() {
    final currentIndex = state.songSources.indexOf(state.song!);
    if (currentIndex == state.songSources.length - 1 && state.isRepeat) {
      _playSongAtIndex(0);
      return;
    }
    if (currentIndex < state.songSources.length - 1) {
      final nextIndex = currentIndex + 1;
      _playSongAtIndex(nextIndex);
    } else {
      'User played all song'.logD;
      _audioPlayer.stop();
    }
  }

  void _playNetworkNext() {
    final currentIndex = state.songSources.indexOf(state.song!);

    // Load more songs if we're near the end
    if (currentIndex >= state.songSources.length - 3 && hasMoreSearchResults) {
      final nextPage = _page + 1;
      setNetworkSource(type: _type!, query: _query!, page: nextPage);
    }

    if (currentIndex == state.songSources.length - 1 && state.isRepeat) {
      _playSongAtIndex(0);
      return;
    }
    if (currentIndex < state.songSources.length - 1) {
      final nextIndex = currentIndex + 1;
      _playSongAtIndex(nextIndex);
    } else {
      'User played all song'.logD;
      _audioPlayer.stop();
      emit(state.copyWith(playState: AudioPlayState.idle));
    }
  }

  void _playSongAtIndex(int index) {
    final song = state.songSources[index];
    setLocalSource(song: song, source: state.songSources);
  }

  /// Sets audio source from local database
  void setLocalSource({required DbSongModel song, required List<DbSongModel> source}) {
    if (_type != null) {
      _page = 1;
      _query = null;
      _type = null;
    }
    emit(state.copyWith(song: song, songSources: source, originSongSources: source, playState: AudioPlayState.loading));
    _playSong();
    _addToRecentPlayed(song);
  }

  Future<void> _playSong() async {
    final song = state.song;
    if (song == null || (song.downloadUrl?.isEmpty ?? true)) {
      'Please select a valid song'.showErrorAlert();
      emit(state.copyWith(playState: AudioPlayState.error));
      return;
    }

    final url = song.downloadUrl!.last.url;
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

  /// Sets audio source from network based on type
  void setNetworkSource({
    required SourceType type,
    required String query,
    String? songId,
    int page = 0,
    List<DbSongModel>? sources,
  }) {
    _type = type;
    _query = query;
    _page = page;

    switch (type) {
      case SourceType.searchSong:
        if (sources == null) {
          _searchSongs(query: query, page: page, songId: songId);
        } else {
          emit(state.copyWith(songSources: sources, originSongSources: sources));
          final currentIndex = state.songSources.indexWhere((element) => element.id == songId);
          _playSongAtIndex(currentIndex);
        }
      case SourceType.searchPlaylistSong:
      // TODO(VIVEK): Implement playlist song search
      case SourceType.searchArtistSong:
      // TODO(VIVEK): Implement artist song search
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
  void playNextSong() {
    'Ids : ${state.songSources.map((e) => e.id).toList()}'.logD;
    if (_type == null) {
      _playLocalNext();
    } else {
      _playNetworkNext();
    }
  }

  /// Play Previous Song
  void playPreviousSong() {
    final index = state.songSources.indexOf(state.song!);
    if (index > 0) {
      _playSongAtIndex(index - 1);
    }
  }

  /// Toggle Like Song
  void toggleLikeSong({bool? isLiked}) {
    final song = state.song?.copyWith(isLiked: isLiked ?? !(state.song?.isLiked ?? false));
    final sourceList = state.songSources.toList();
    sourceList[sourceList.indexOf(state.song!)] = song!;
    emit(state.copyWith(song: song, songSources: sourceList));
    if (isLiked == null) DatabaseHandler.toggleLikedSong(song);
  }

  /// Toggle Repeat Song
  void toggleRepeatSong() {
    emit(state.copyWith(isRepeat: !state.isRepeat));
  }

  /// Toggle Shuffle Song
  void toggleShuffleSong() {
    if (!state.isShuffle) {
      final list =
          state.songSources.toList()
            ..removeWhere((element) => element.id == state.song?.id)
            ..insert(0, state.song!)
            ..shuffle();
      emit(state.copyWith(isShuffle: !state.isShuffle, songSources: list));
    } else {
      final list = state.originSongSources.toList();
      emit(state.copyWith(isShuffle: !state.isShuffle, songSources: list));
    }
  }

  /// For check Like
  void checkLike() {
    final isLiked = DatabaseHandler.isSongLiked(state.song!);
    toggleLikeSong(isLiked: isLiked);
  }
}

///
enum SourceType {
  ///
  searchSong,

  ///
  searchPlaylistSong,

  ///
  searchArtistSong,
}
