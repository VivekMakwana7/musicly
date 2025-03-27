import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'app_state.dart';

/// AppCubit
class AppCubit extends Cubit<AppState> {
  /// Constructor
  AppCubit() : super(AppInitial());

  /// For Artist song played
  void artistSongPlayed(String artistId) {
    emit(ArtistSongPlay(artistId: artistId));
  }

  /// For Album song played
  void albumSongPlayed(String albumId) {
    emit(AlbumSongPlay(albumId: albumId));
  }

  /// For Playlist song played
  void playlistSongPlayed(String playlistId) {
    emit(PlaylistSongPlay(playlistId: playlistId));
  }

  /// For reset State
  void resetState() {
    emit(AppResetState());
  }

  /// For Library song played
  void librarySongPlayed(String libraryId) {
    emit(LibrarySongPlay(libraryId: libraryId));
  }
}
