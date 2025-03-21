import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';
import 'package:musicly/core/enums/audio_play_state.dart';
import 'package:musicly/core/extensions/ext_string_alert.dart';
import 'package:musicly/core/logger.dart';

part 'audio_state.dart';

/// For Handle Audio Operation
class AudioCubit extends Cubit<AudioState> {
  /// Default constructor
  AudioCubit() : super(const AudioState()) {
    _playerStateListener();
  }

  /// Instance of AudioPlayer
  AudioPlayer? audioPlayer = AudioPlayer();

  /// Set Song Source
  void setSource({required DbSongModel song, required List<DbSongModel> songSource}) {
    emit(state.copyWith(song: song, songSources: songSource, playState: AudioPlayState.loading));
    playSong();
  }

  /// For Play Song
  Future<void> playSong() async {
    'Current Playing song : ${state.song?.name} | ${state.song?.id}'.logD;
    if (state.song != null && state.song!.downloadUrl != null && state.song!.downloadUrl!.isNotEmpty) {
      final url = state.song!.downloadUrl!.last.url;
      try {
        await audioPlayer?.setSourceUrl(url);
        if (audioPlayer?.source != null) {
          await audioPlayer?.play(audioPlayer!.source!);
        } else {
          emit(state.copyWith(playState: AudioPlayState.error));
          'Something went wrong!'.showErrorAlert();
        }
      } on Object catch (e) {
        'Exception on Play Audio : $e'.logE;
        'Please try again'.showErrorAlert();
        emit(state.copyWith(playState: AudioPlayState.error));
      }
    } else {
      'Please select valid song'.showErrorAlert();
      emit(state.copyWith(playState: AudioPlayState.error));
    }
  }

  /// For pause song
  Future<void> pauseSong() async {
    await audioPlayer?.pause();
  }

  @override
  Future<void> close() {
    audioPlayer?.dispose();
    return super.close();
  }

  void _playerStateListener() {
    audioPlayer?.onPlayerStateChanged.listen((playerState) {
      switch (playerState) {
        case PlayerState.stopped:
          emit(state.copyWith(playState: AudioPlayState.error));
        case PlayerState.playing:
          emit(state.copyWith(playState: AudioPlayState.play));
        case PlayerState.paused:
          emit(state.copyWith(playState: AudioPlayState.pause));
        case PlayerState.completed:
          emit(state.copyWith(playState: AudioPlayState.loading));
          final index = state.songSources.indexOf(state.song!);
          if (index < state.songSources.length - 1) {
            setSource(song: state.songSources[index + 1], songSource: state.songSources);
          } else {
            setSource(song: state.songSources[0], songSource: state.songSources);
            emit(state.copyWith(playState: AudioPlayState.idle));
          }
        case PlayerState.disposed:
          emit(state.copyWith(playState: AudioPlayState.idle));
      }
    });
  }
}
