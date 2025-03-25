import 'package:meta/meta.dart';
import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/enums/api_state.dart';
import 'package:musicly/core/extensions/ext_string_alert.dart';
import 'package:musicly/core/logger.dart';
import 'package:musicly/core/paginated/paginated_cubit.dart';
import 'package:musicly/core/rest_utils/api_request.dart';
import 'package:musicly/repos/search_repository.dart';
import 'package:musicly/src/search/pages/song/search_song_page.dart';

part 'search_song_state.dart';

/// [SearchSongPage]'s cubit
class SearchSongCubit extends PaginatedCubit<SearchSongState> {
  /// [SearchSongPage]'s cubit constructor
  SearchSongCubit({this.query}) : super(const SearchSongState());

  /// For search songs
  final String? query;

  final _appDb = Injector.instance<AppDB>();
  final _searchRepo = Injector.instance<SearchRepository>();

  @override
  ApiState get apiState => state.apiState;

  @override
  Future<void> getData() async {
    // Case query is not equal to null means Search data from Server
    // Other wise Search song page open for search from Local database
    if (query != null) {
      emit(state.copyWith(apiState: state.songs.isEmpty ? ApiState.loading : ApiState.loadingMore));
      final param = {'query': query, 'page': page, 'limit': limit};
      final res = await _searchRepo.searchSongByQuery(ApiRequest(params: param));
      res.when(
        success: (data) {
          hasMoreData = data.results?.isNotEmpty ?? false;
          emit(state.copyWith(apiState: ApiState.success, songs: [...state.songs, ...?data.results]));
        },
        error: (exception) {
          'Search song by Query API failed : $exception'.logE;
          emit(state.copyWith(apiState: ApiState.error));
          exception.message.showErrorAlert();
        },
      );
    } else {
      emit(state.copyWith(apiState: ApiState.success, songs: _appDb.songSearchHistory));
    }
  }
}
