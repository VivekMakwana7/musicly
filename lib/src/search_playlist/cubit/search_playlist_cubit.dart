import 'package:meta/meta.dart';
import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/db/models/playlist/db_playlist_model.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/enums/api_state.dart';
import 'package:musicly/core/extensions/ext_string_alert.dart';
import 'package:musicly/core/logger.dart';
import 'package:musicly/core/paginated/paginated_cubit.dart';
import 'package:musicly/core/rest_utils/api_request.dart';
import 'package:musicly/repos/search_repository.dart';
import 'package:musicly/src/search_playlist/search_playlist_page.dart';

part 'search_playlist_state.dart';

/// For handle [SearchPlaylistPage]'s state
class SearchPlaylistCubit extends PaginatedCubit<SearchPlaylistState> {
  /// Search Playlist Cubit Constructor
  SearchPlaylistCubit({this.query}) : super(const SearchPlaylistState());

  /// For API call
  final String? query;

  final _appDb = Injector.instance<AppDB>();
  final _searchRepo = Injector.instance<SearchRepository>();

  @override
  ApiState get apiState => state.apiState;

  @override
  Future<void> getData() async {
    'query : $query'.logD;
    if (query != null) {
      emit(state.copyWith(apiState: state.playlists.isEmpty ? ApiState.loading : ApiState.loadingMore));
      final param = {'query': query, 'limit': limit, 'page': page};
      final res = await _searchRepo.searchPlaylistByQuery(ApiRequest(params: param));

      res.when(
        success: (data) {
          hasMoreData = data.results?.isNotEmpty ?? false;
          emit(state.copyWith(apiState: ApiState.success, playlists: [...state.playlists, ...?data.results]));
        },
        error: (exception) {
          'Search Playlist by Query API failed : $exception'.logE;
          exception.message.showErrorAlert();
          emit(state.copyWith(apiState: ApiState.error));
        },
      );
    } else {
      emit(state.copyWith(apiState: ApiState.success, playlists: _appDb.playlistSearchHistory));
    }
  }
}
