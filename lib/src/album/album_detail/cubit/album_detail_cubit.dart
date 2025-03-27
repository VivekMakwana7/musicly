import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:musicly/core/db/data_base_handler.dart';
import 'package:musicly/core/db/models/album/db_album_model.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/enums/api_state.dart';
import 'package:musicly/core/extensions/ext_string_alert.dart';
import 'package:musicly/core/logger.dart';
import 'package:musicly/core/rest_utils/api_request.dart';
import 'package:musicly/repos/search_repository.dart';
import 'package:musicly/src/album/album_detail/album_detail_page.dart';

part 'album_detail_state.dart';

/// For handler [AlbumDetailPage]'s state
class AlbumDetailCubit extends Cubit<AlbumDetailState> {
  /// Default constructor
  AlbumDetailCubit({required this.albumId}) : super(const AlbumDetailState()) {
    _getAlbumDetails();
  }

  /// For get album detail
  final String albumId;
  final _searchRepo = Injector.instance<SearchRepository>();

  Future<void> _getAlbumDetails() async {
    'albumId : $albumId'.logD;
    emit(state.copyWith(apiState: ApiState.loading));
    final res = await _searchRepo.searchAlbumById(ApiRequest(params: {'id': albumId}));

    res.when(
      success: (data) {
        emit(state.copyWith(apiState: ApiState.success, album: data));
        DatabaseHandler.addToAlbumSearchHistory(data);
      },
      error: (exception) {
        'Album by Id API failed : $exception'.logE;
        exception.message.showErrorAlert();
        emit(state.copyWith(apiState: ApiState.error));
      },
    );
  }
}
