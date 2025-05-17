import 'package:meta/meta.dart';
import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/db/models/artist/db_artist_model.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/enums/api_state.dart';
import 'package:musicly/core/extensions/ext_string_alert.dart';
import 'package:musicly/core/logger.dart';
import 'package:musicly/core/paginated/paginated_cubit.dart';
import 'package:musicly/core/rest_utils/api_request.dart';
import 'package:musicly/repos/music_repo.dart';
import 'package:musicly/src/artist/search_artist_page.dart';

part 'search_artist_state.dart';

/// For handle [SearchArtistPage]'s state
class SearchArtistCubit extends PaginatedCubit<SearchArtistState> {
  /// Default constructor
  SearchArtistCubit({this.query}) : super(const SearchArtistState());

  /// The search query used to find these artist (if applicable).
  final String? query;

  final _searchManager = AppDB.searchManager;
  final _searchRepo = Injector.instance<MusicRepo>();

  @override
  ApiState get apiState => state.apiState;

  @override
  int get limit => 24;

  @override
  Future<void> getData() async {
    if (query != null) {
      emit(state.copyWith(apiState: state.artists.isEmpty ? ApiState.loading : ApiState.loadingMore));
      final param = {'query': query, 'page': page, 'limit': limit};
      final res = await _searchRepo.searchArtistByQuery(ApiRequest(params: param));

      res.when(
        success: (data) {
          hasMoreData = data.results?.isNotEmpty ?? false;
          emit(state.copyWith(apiState: ApiState.success, artists: [...state.artists, ...?data.results]));
        },
        error: (exception) {
          exception.message.showErrorAlert();
          'Search Artist By Query API failed : $exception'.logE;
          emit(state.copyWith(apiState: ApiState.error));
        },
      );
    } else {
      emit(state.copyWith(apiState: ApiState.success, artists: _searchManager.searchedArtists));
    }
  }
}
