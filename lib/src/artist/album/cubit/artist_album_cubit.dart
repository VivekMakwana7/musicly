import 'package:meta/meta.dart';
import 'package:musicly/core/db/models/album/db_album_model.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/enums/api_state.dart';
import 'package:musicly/core/extensions/ext_string_alert.dart';
import 'package:musicly/core/logger.dart';
import 'package:musicly/core/paginated/paginated_cubit.dart';
import 'package:musicly/core/rest_utils/api_request.dart';
import 'package:musicly/repos/music_repo.dart';
import 'package:musicly/src/artist/album/artist_album_page.dart';

part 'artist_album_state.dart';

/// For handle [ArtistAlbumPage]'s state
class ArtistAlbumCubit extends PaginatedCubit<ArtistAlbumState> {
  /// Artist Album Cubit constructor
  ArtistAlbumCubit({required this.artistId}) : super(const ArtistAlbumState());

  /// For get Artist Album list
  final String artistId;

  final _searchRepo = Injector.instance<MusicRepo>();

  ///
  int _page = 0;

  @override
  int get page => _page;

  ///
  @override
  set page(int value) {
    _page = value;
  }

  @override
  int get limit => 12;

  @override
  ApiState get apiState => state.apiState;

  @override
  Future<void> getData() async {
    emit(state.copyWith(apiState: state.albums.isEmpty ? ApiState.loading : ApiState.loadingMore));
    final param = {
      'page': page,
      'sortBy': 'popularity',
      // 'latest','alphabetical',
      'sortOrder': 'asc',
      // 'desc'
    };
    final res = await _searchRepo.getArtistAlbum(artistId, ApiRequest(params: param));
    res.when(
      success: (data) {
        hasMoreData = data.albums?.isNotEmpty ?? false;
        emit(state.copyWith(apiState: ApiState.success, albums: [...state.albums, ...?data.albums]));
        'state : ${state.albums.length}'.logD;
      },
      error: (exception) {
        'Search Album By Query API failed : $exception'.logE;
        emit(state.copyWith(apiState: ApiState.error));
        exception.message.showErrorAlert();
      },
    );
  }
}
