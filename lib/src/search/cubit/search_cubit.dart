import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/enums/api_state.dart';
import 'package:musicly/core/logger.dart';
import 'package:musicly/core/rest_utils/api_request.dart';
import 'package:musicly/repos/music_repo.dart';
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
  final _searchRepo = Injector.instance<MusicRepo>();
  CancelToken? _cancelToken;

  late final PublishSubject<String> _searchTextQuery = PublishSubject();

  ///
  final isSearchedDataEmpty = ValueNotifier(AppDB.searchManager.isSearchedEmpty);

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
    isSearchedDataEmpty.dispose();
    return super.close();
  }

  /// init all listener
  void _initListener() {
    _searchTextQuery.debounceTime(const Duration(milliseconds: 500)).distinct().listen((event) {
      globalSearch();
    });
    searchController.addListener(_searchControllerListener);
    _searchPageDatabaseListener();
  }

  void _searchControllerListener() {
    _searchTextQuery.add(searchController.text.trim());
  }

  /// For handle Clear API Search and Clear field
  void onClearFieldTap() {
    searchController.clear();
  }

  void _searchPageDatabaseListener() {
    AppDB.searchManager.searchedSongStream().listen((event) {
      isSearchedDataEmpty.value = AppDB.searchManager.isSearchedEmpty;
    });
    AppDB.searchManager.searchedAlbumStream().listen((event) {
      isSearchedDataEmpty.value = AppDB.searchManager.isSearchedEmpty;
    });
    AppDB.searchManager.searchedArtistStream().listen((event) {
      isSearchedDataEmpty.value = AppDB.searchManager.isSearchedEmpty;
    });
    AppDB.searchManager.searchedPlaylistStream().listen((event) {
      isSearchedDataEmpty.value = AppDB.searchManager.isSearchedEmpty;
    });
  }
}
