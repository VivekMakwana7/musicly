import 'package:meta/meta.dart';
import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/db/models/album/db_album_model.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/enums/api_state.dart';
import 'package:musicly/core/extensions/ext_string_alert.dart';
import 'package:musicly/core/logger.dart';
import 'package:musicly/core/paginated/paginated_cubit.dart';
import 'package:musicly/core/rest_utils/api_request.dart';
import 'package:musicly/repos/music_repo.dart';
import 'package:musicly/src/album/search_album_page.dart';

part 'search_album_state.dart';

/// For handle [SearchAlbumPage]'s state
class SearchAlbumCubit extends PaginatedCubit<SearchAlbumState> {
  /// Default constructor
  SearchAlbumCubit({this.query}) : super(const SearchAlbumState());

  /// For search albums
  final String? query;

  final SearchManager _searchManager = AppDB.searchManager;
  final MusicRepo _searchRepo = Injector.instance<MusicRepo>();

  @override
  ApiState get apiState => state.apiState;

  @override
  int get limit => 12;

  @override
  Future<void> getData() async {
    if (query != null) {
      emit(
        state.copyWith(
          apiState:
              state.albums.isEmpty ? ApiState.loading : ApiState.loadingMore,
        ),
      );
      final param = {'query': query, 'page': page, 'limit': limit};
      final res = await _searchRepo.searchAlbumByQuery(
        ApiRequest(params: param),
      );
      res.when(
        success: (data) {
          hasMoreData = data.results?.isNotEmpty ?? false;
          emit(
            state.copyWith(
              apiState: ApiState.success,
              albums: [...state.albums, ...?data.results],
            ),
          );
          'param : ${state.albums.length}'.logD;
        },
        error: (exception) {
          'Search Album By Query API failed : $exception'.logE;
          emit(state.copyWith(apiState: ApiState.error));
          exception.message.showErrorAlert();
        },
      );
    } else {
      emit(
        state.copyWith(
          apiState: ApiState.success,
          albums: _searchManager.searchedAlbums,
        ),
      );
    }
  }
}
