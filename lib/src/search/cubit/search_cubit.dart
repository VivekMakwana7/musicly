import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/db/models/recent_played_song_model.dart';
import 'package:musicly/core/db/models/search_history_model.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/enums/api_state.dart';
import 'package:musicly/core/logger.dart';
import 'package:musicly/core/rest_utils/api_request.dart';
import 'package:musicly/repos/search_repository.dart';
import 'package:musicly/src/search/model/global_search_model.dart';
import 'package:pkg_dio/pkg_dio.dart';
import 'package:rxdart/rxdart.dart';

part 'search_state.dart';

/// For handle Search page state
class SearchCubit extends Cubit<SearchState> {
  /// Search cubit constructor
  SearchCubit() : super(const SearchState()) {
    _initListener();
  }

  /// Search controller
  final searchController = TextEditingController();
  final _searchRepo = Injector.instance<SearchRepository>();
  CancelToken? _cancelToken;

  late final PublishSubject<String> _searchTextQuery = PublishSubject();

  /// Local database Instance
  final appDb = Injector.instance<AppDB>();

  /// Global Search
  Future<void> globalSearch() async {
    if (searchController.text.trim().isEmpty) {
      return;
    }
    emit(state.copyWith(apiState: ApiState.loading));
    _cancelToken?.cancel();
    _cancelToken = CancelToken();

    final request = {'query': searchController.text.trim()};
    final res = await _searchRepo.search(ApiRequest(params: request, cancelToken: _cancelToken, hideKeyboard: false));

    res.when(
      success: (data) {
        'Top trending : ${data.topTrending.length}'.logD;
        emit(state.copyWith(apiState: ApiState.success, searchModel: data));
      },
      error: (exception) {
        'Search API failed : $exception'.logE;
        emit(state.copyWith(apiState: ApiState.error));
      },
    );
  }

  @override
  Future<void> close() {
    searchController
      ..removeListener(_searchControllerListener)
      ..dispose();
    _searchTextQuery.close();
    _cancelToken?.cancel();
    return super.close();
  }

  /// init all listener
  void _initListener() {
    _searchTextQuery.debounceTime(const Duration(milliseconds: 300)).distinct().listen((event) {
      globalSearch();
    });
    searchController.addListener(_searchControllerListener);
  }

  void _searchControllerListener() {
    _searchTextQuery.add(searchController.text.trim());
  }

  /// on top trendy item tap
  void onTopTrendyItemTap(int index) {
    final item = state.searchModel!.topTrending[index];
    _handleSearchHistory(item.toSearchHistoryModel());
  }

  /// on Song Item Tap
  void onSongItemTap(int index) {
    final item = state.searchModel!.songs[index];
    _handleSearchHistory(item.toSearchHistoryModel());
    _handleRecentPlayedSong(item.toRecentPlayedSongModel());
  }

  /// on Album Item Tap
  void onAlbumItemTap(int index) {
    final item = state.searchModel!.albums[index];
    _handleSearchHistory(item.toSearchHistoryModel());
  }

  /// on Artist Item Tap
  void onArtistItemTap(int index) {
    final item = state.searchModel!.artists[index];
    _handleSearchHistory(item.toSearchHistoryModel());
  }

  void _handleSearchHistory(SearchHistoryModel item) {
    final history = appDb.searchHistory..insert(0, item);
    appDb.searchHistory = history;
  }

  void _handleRecentPlayedSong(RecentPlayedSongModel item) {
    final recentPlayed = appDb.recentPlayedSongList..insert(0, item);
    appDb.recentPlayedSongList = recentPlayed;
  }

  /// For handle Clear API Search and Clear field
  void onClearFieldTap() {
    searchController.clear();
  }
}
