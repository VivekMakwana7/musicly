part of 'search_cubit.dart';

/// Search State
@immutable
final class SearchState {
  /// Search State constructor
  const SearchState({this.apiState = ApiState.idle, this.searchModel});

  /// Search API current state
  final ApiState apiState;

  /// Search Model
  final GlobalSearchModel? searchModel;

  /// Copy with method
  SearchState copyWith({ApiState? apiState, GlobalSearchModel? searchModel}) {
    return SearchState(apiState: apiState ?? this.apiState, searchModel: searchModel ?? this.searchModel);
  }
}
