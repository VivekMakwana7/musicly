import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:musicly/core/db/data_base_handler.dart';
import 'package:musicly/core/db/models/playlist/db_playlist_model.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/enums/api_state.dart';
import 'package:musicly/core/extensions/ext_string_alert.dart';
import 'package:musicly/core/logger.dart';
import 'package:musicly/core/rest_utils/api_request.dart';
import 'package:musicly/repos/music_repo.dart';
import 'package:musicly/src/search_playlist/playlist_detail/playlist_detail_page.dart';

part 'playlist_detail_state.dart';

/// For handler [PlaylistDetailPage]'s state
class PlaylistDetailCubit extends Cubit<PlaylistDetailState> {
  /// Playlist Detail Cubit constructor
  PlaylistDetailCubit({required this.playlistId}) : super(const PlaylistDetailState()) {
    _getPlaylistDetail();
  }

  /// For get playlist details
  final String playlistId;

  final _searchRepo = Injector.instance<MusicRepo>();

  Future<void> _getPlaylistDetail() async {
    emit(state.copyWith(apiState: ApiState.loading));
    final res = await _searchRepo.searchPlaylistById(ApiRequest(params: {'id': playlistId}));

    res.when(
      success: (data) {
        emit(state.copyWith(apiState: ApiState.success, playlist: data));
        DatabaseHandler.addToPlaylistSearchHistory(data);
      },
      error: (exception) {
        exception.message.showErrorAlert();
        'Search playlist by Id API failed : $exception'.logE;
        emit(state.copyWith(apiState: ApiState.error));
      },
    );
  }
}
