import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:musicly/core/db/data_base_handler.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';

part 'app_state.dart';

/// AppCubit
class AppCubit extends Cubit<AppState> {
  /// Constructor
  AppCubit() : super(AppInitial());

  /// Toggle liked
  void toggleLiked(DbSongModel song) {
    DatabaseHandler.toggleLikedSong(song, showToast: true);

    emit(SongLikeUpdate(songId: song.id, isLiked: DatabaseHandler.isSongLiked(song)));
  }
}
