import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:musicly/core/db/models/artist/db_artist_model.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/enums/api_state.dart';
import 'package:musicly/core/extensions/ext_string_alert.dart';
import 'package:musicly/core/logger.dart';
import 'package:musicly/core/rest_utils/api_request.dart';
import 'package:musicly/repos/search_repository.dart';
import 'package:musicly/src/artist/artist_detail/artist_detail_page.dart';

part 'artist_detail_state.dart';

/// For handler [ArtistDetailPage]'s state
class ArtistDetailCubit extends Cubit<ArtistDetailState> {
  /// Artist Detail Cubit constructor
  ArtistDetailCubit({required this.artistId}) : super(const ArtistDetailState()) {
    _getArtistDetail();
  }

  /// For get Artist details
  final String artistId;

  final _searchRepo = Injector.instance<SearchRepository>();

  Future<void> _getArtistDetail() async {
    emit(state.copyWith(apiState: ApiState.loading));
    final res = await _searchRepo.searchArtistById(ApiRequest(pathParameter: artistId));

    res.when(
      success: (data) {
        emit(state.copyWith(apiState: ApiState.success, artist: data));
      },
      error: (exception) {
        'Artist detail API failed : $exception'.logE;
        exception.message.showErrorAlert();
        emit(state.copyWith(apiState: ApiState.error));
      },
    );
  }
}
