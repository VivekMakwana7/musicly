import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicly/bootstrap.dart';
import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/db/data_base_handler.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/enums/audio_play_state.dart';
import 'package:musicly/core/extensions/ext_string.dart';
import 'package:musicly/core/extensions/ext_string_alert.dart';
import 'package:musicly/core/logger.dart';
import 'package:musicly/core/source_handler/source_handler.dart';
import 'package:musicly/core/source_handler/source_type.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pkg_dio/pkg_dio.dart';

part 'audio_state.dart';

/// For Handle Audio Operation
class AudioCubit extends Cubit<AudioState> with WidgetsBindingObserver {
  /// Default constructor
  AudioCubit() : super(const AudioState()) {
    WidgetsBinding.instance.addObserver(this);
  }

  late final _homeManager = AppDB.homeManager;

  /// Handles changes in the player state (playing/paused).
  void handlePlayerStateChange(PlayerState playerState) {
    if (state.currentSource != null) {
      emit(
        state.copyWith(
          playState:
              playerState.playing
                  ? AudioPlayState.play
                  : playerState.processingState == ProcessingState.idle
                  ? AudioPlayState.idle
                  : AudioPlayState.pause,
        ),
      );
    } else {
      emit(state.copyWith(playState: AudioPlayState.idle));
    }
  }

  /// Handles changes in the current audio position.
  void handlePositionChange(Duration position) {
    emit(state.copyWith(positioned: position));
  }

  /// Handles changes in the total duration of the audio.
  void handleDurationChange(Duration? duration) {
    emit(state.copyWith(duration: duration));
  }

  /// Handles changes in the shuffle mode.
  void handleShuffleModeChange({bool isShuffle = false}) {
    emit(state.copyWith(isShuffle: isShuffle));
  }

  @override
  Future<void> close() {
    audioPlayer?.stop();
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }

  void _addToRecentPlayed(DbSongModel song) {
    final recentPlayedSongs =
        _homeManager.recentPlayedSongs
          ..removeWhere((element) => element.id == song.id)
          ..insert(0, song);
    _homeManager.recentPlayedSongs = recentPlayedSongs.toSet().toList();
  }

  /// For toggle Play Pause
  Future<void> togglePlayPause() async {
    if (state.playState == AudioPlayState.play) {
      await Injector.instance<AudioPlayer>().pause();
    } else {
      await Injector.instance<AudioPlayer>().play();
    }
  }

  /// For seek to given positioned
  Future<void> seekToPosition(double positioned, double maxPositioned) async {
    final positionedInMilliSeconds =
        (positioned * state.duration.inMilliseconds) / maxPositioned;
    await audioPlayer?.seek(
      Duration(milliseconds: positionedInMilliSeconds.toInt()),
    );
  }

  /// Play Next Song
  Future<void> playNextSong() async {
    if (state.currentSource != null) {
      await _loadMoreData();
      await audioPlayer?.skipToNext();
    } else {
      'Source not found'.logE;
    }
  }

  /// Play Previous Song
  Future<void> playPreviousSong() async {
    if (state.currentSource != null) {
      await audioPlayer?.skipToPrevious();
    } else {
      'Source not found'.logE;
    }
  }

  /// Toggle Like Song
  void toggleLikeSong({bool? isLiked}) {
    if (state.currentSource != null) {
      final song = state.song?.copyWith(
        isLiked: isLiked ?? !(state.song?.isLiked ?? false),
      );
      emit(state.copyWith(song: song));
      if (isLiked == null) DatabaseHandler.toggleLikedSong(song!);
    } else {
      'Source not found'.logE;
    }
  }

  /// Toggle Repeat Song
  Future<void> toggleRepeatSong() async {
    final mode = switch (state.loopMode) {
      LoopMode.off => LoopMode.one,
      LoopMode.one => LoopMode.all,
      LoopMode.all => LoopMode.off,
    };
    emit(state.copyWith(loopMode: mode));

    await Injector.instance<AudioPlayer>().setLoopMode(mode);
  }

  /// Toggle Shuffle Song
  Future<void> toggleShuffleSong() async {
    await audioPlayer?.setShuffleMode(
      state.isShuffle
          ? AudioServiceShuffleMode.all
          : AudioServiceShuffleMode.none,
    );
  }

  /// For check Like
  void _checkLike(DbSongModel song) {
    final isLiked = DatabaseHandler.isSongLiked(song);
    toggleLikeSong(isLiked: isLiked);
  }

  /// Load source data by SourceType
  Future<void> loadSourceData({
    required SourceType type,
    required String songId,
    required int page,
    required bool isPaginated,
    String? query,
    List<DbSongModel> songs = const [],
    String? albumId,
    String? artistId,
    String? playlistId,
  }) async {
    emit(state.copyWith(playState: AudioPlayState.loading));
    'Assigning new source and play song\nSource data : [$type]\nSong will play: $songId\nSearch Query: $query\nPage number : $page'
        .logD;
    if (songs.isNotEmpty) {
      'Load Sources : ${songs.map((e) => e.id).toList()}'.logD;
    }

    final newSource =
        songs.isEmpty
            ? await _getSourceData(
              type,
              page: page,
              artistId: artistId,
              query: query,
              playlistId: playlistId,
              albumId: albumId,
              isPaginated: isPaginated,
            )
            : SourceData(
              songs: songs,
              sourceType: type,
              currentPage: page,
              query: query,
              playlistId: playlistId,
              artistId: artistId,
              albumId: albumId,
              isPaginated: isPaginated,
            );
    emit(state.copyWith(currentSource: newSource));
    if (state.currentSource != null) {
      final songIndex = state.currentSource!.songs.indexWhere(
        (element) => element.id == songId,
      );
      'songIndex : $songIndex || ${state.currentSource!.songs.map((e) => e.id).toList()}'
          .logD;

      await _setSource(songIndex, isFromLoadSource: true);
    } else {
      'Source not found'.logE;
      'Source not found'.showErrorAlert();
    }
  }

  /// Sets the audio source and starts playing the song at the given index.
  Future<void> _setSource(int index, {bool isFromLoadSource = false}) async {
    final songSource =
        state.currentSource!.songs.map(_songToMediaItem).toList();
    await audioPlayer?.initSongs(
      songSource,
      index: index,
      isFromDownload: state.currentSource!.sourceType == SourceType.downloaded,
    );
    final song = state.currentSource!.songs[index];
    if (isFromLoadSource) _addSearchHistory(song);
  }

  /// Loads more data for paginated sources when nearing the end of the current playlist.
  Future<void> _loadMoreData() async {
    if (state.currentSource != null &&
        state.currentSource!.isPaginated &&
        ((state.currentSource!.songs.length - state.currentIndex) < 4)) {
      final newData = await _getSourceData(
        state.currentSource!.sourceType,
        albumId: state.currentSource?.albumId,
        playlistId: state.currentSource?.playlistId,
        query: state.currentSource?.query,
        artistId: state.currentSource?.artistId,
        page: state.currentSource!.currentPage + 1,
        isPaginated: state.currentSource!.isPaginated,
      );
      final updatedSource = state.currentSource!.copyWith(
        songs: [...state.currentSource!.songs, ...newData.songs],
        currentPage: newData.currentPage,
        hasMoreData: newData.hasMoreData,
      );
      emit(state.copyWith(currentSource: updatedSource));

      if (newData.songs.isNotEmpty) {
        await audioPlayer?.addQueueItems(
          List.generate(
            newData.songs.length,
            (index) => _songToMediaItem(newData.songs[index]),
          ),
        );
      }
    }
  }

  /// Adds the currently played song to the search history if the source is a search result.
  void _addSearchHistory(DbSongModel song) {
    if (state.currentSource != null &&
        state.currentSource!.sourceType == SourceType.search) {
      DatabaseHandler.addToSongSearchHistory(song);
    }
  }

  /// Initializes the state with the currently playing song's details.
  void playingSongAtIndex(int index) {
    if (state.currentSource != null) {
      final song = state.currentSource!.songs[index];
      emit(
        state.copyWith(
          song: song,
          currentIndex: index,
          isNextDisabled: !audioPlayer!.player.hasNext,
        ),
      );
      _checkLike(song);
      if (state.currentSource!.sourceType != SourceType.downloaded) {
        _addToRecentPlayed(song);
      }
    }
  }

  /// Fetches source data based on the provided SourceType and parameters.
  Future<SourceData> _getSourceData(
    SourceType type, {
    String? query,
    String? albumId,
    String? artistId,
    String? playlistId,
    int page = 1,
    bool isPaginated = true,
  }) {
    final handler = SourceHandler.sources.firstWhere(
      (h) => h.sourceType == type,
    );
    return switch (type) {
      SourceType.recentPlayed ||
      SourceType.liked ||
      SourceType.searchHistory ||
      SourceType.playlist ||
      SourceType.downloaded => handler.getDatabaseData(),
      SourceType.search => handler.getSearchSongData(
        query: query ?? '',
        page: page,
      ),
      SourceType.searchAlbum => handler.getAlbumSongData(
        albumId: albumId!,
        page: page,
      ),
      SourceType.searchArtist => handler.getArtistSongData(
        artistId: artistId!,
        page: page,
      ),
      SourceType.searchPlaylist => handler.getPlaylistSongData(
        playlistId: playlistId!,
      ),
    };
  }

  /// Add song in queue
  void addSongToQueue(DbSongModel song) {
    audioPlayer?.addQueueItem(_songToMediaItem(song));
    '${song.name?.formatSongTitle} added in queue'.showSuccessAlert();
  }

  MediaItem _songToMediaItem(DbSongModel song) {
    return MediaItem(
      id: song.audioUrl ?? '',
      album: song.album?.name ?? '',
      title: song.name ?? '',
      artist:
          (song.artists?.primary ?? []).isNotEmpty
              ? song.artists?.primary?.first.name
              : '',
      artUri: Uri.parse(song.image?.last.url ?? ''),
      duration: Duration(seconds: song.duration ?? 50),
    );
  }

  /// For download given song
  Future<void> downloadSong({
    required DbSongModel song,
    required String quality,
    bool showToast = true,
  }) async {
    final dSong = song;
    final appDir = await getApplicationDocumentsDirectory();
    final appFolderPath = '${appDir.path}/Musicly';
    final filePath = '$appFolderPath/${dSong.name?.formatSongTitle}.mp3';

    final songFile = File(filePath);
    if (songFile.existsSync()) {
      'Already exist '.logD;
      if (showToast) 'Song already downloaded'.showErrorAlert();
      return;
    }
    final dio = Dio();

    try {
      final downloadUrl = dSong.downloadURL(quality) ?? '';

      if (downloadUrl.isEmpty) {
        'Error downloading song: URL can not be empty'.logE;
        if (showToast) 'Song URL not found'.showErrorAlert();
        return;
      }

      await dio.download(dSong.downloadURL(quality) ?? '', filePath);
      final songFile = File(filePath);
      if (songFile.existsSync()) {
        DatabaseHandler.addToDownloadedSongs(
          dSong.copyWith(devicePath: filePath),
        );

        if (showToast) 'Song downloaded successfully'.showSuccessAlert();
      } else {
        if (showToast) 'Failed to download song'.showErrorAlert();
      }
    } on Object catch (e) {
      'Error downloading song: $e'.logE;
      'Failed to download song'.showErrorAlert();
    }
  }

  /// Add songs in queue
  void addSongsToQueue(List<DbSongModel> songs) {
    final item = songs.map(_songToMediaItem).toList();
    audioPlayer?.addQueueItems(item);
    'songs added in queue'.showSuccessAlert();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        audioPlayer?.stop();
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
      case _:
        'do nothing on other state'.logD;
    }
  }
}
