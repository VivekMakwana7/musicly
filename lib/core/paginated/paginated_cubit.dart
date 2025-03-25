import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:musicly/core/enums/api_state.dart';
import 'package:pkg_dio/pkg_dio.dart';

/// A base cubit for managing paginated data.
///
/// This cubit provides functionality for fetching data in pages, handling
/// loading states, and refreshing data. Subclasses should implement the
/// [getData] method to fetch data from their specific data source.
abstract class PaginatedCubit<T> extends Cubit<T> {
  /// Creates a [PaginatedCubit] with an initial state.
  ///
  /// The [initialState] is the initial state of the cubit.
  /// The cubit will automatically fetch the first page of data when it is
  /// initialized.
  PaginatedCubit(super.initialState) {
    getData();
  }

  /// The current page number for pagination.
  ///
  /// This value is incremented automatically when more data is loaded.
  int page = 1;

  /// The number of items to fetch per page.
  ///
  /// This value is set to 10 by default.
  final int limit = 10;

  /// Indicates whether there is more data to load.
  ///
  /// This value is updated based on the response from the API data.
  bool hasMoreData = false;

  /// Cancel token for canceling ongoing requests.
  ///
  /// This token can be used to cancel requests when they are no longer needed,
  /// such as when the cubit is closed or when the data is refreshed.
  CancelToken? cancelToken;

  /// Returns the current API state.
  ///
  /// This method is used to check the current state of the API request
  /// during page scroll.
  ///
  /// **Override this method in your subclass to provide the current API state
  /// from your cubit's state.**
  ApiState get apiState;

  /// Fetches data from the API or data source.
  ///
  /// **Override this method in your subclass to implement the data fetching logic.**
  ///
  /// This method is called automatically when the cubit is initialized and
  /// when the user scrolls to the end of the list.
  ///
  /// The [page] parameter indicates the current page number to fetch.
  /// The [limit] parameter indicates the number of items to fetch per page.
  Future<void> getData();

  @override
  Future<void> close() {
    cancelToken?.cancel();
    return super.close();
  }

  /// Scroll listener for pagination.
  ///
  /// This listener is used to detect when the user has scrolled to the end of
  /// the list and trigger the loading of more data.
  bool scrollListener(ScrollNotification notification) {
    if (hasMoreData &&
        notification.metrics.pixels >= (notification.metrics.maxScrollExtent - 300) &&
        apiState != ApiState.loading &&
        apiState != ApiState.loadingMore) {
      _loadMoreData();
    }
    return false;
  }

  /// Loads more data when scrolling reaches the threshold.
  void _loadMoreData() {
    page++;
    getData();
  }

  /// Refreshes the data by resetting the page and fetching data.
  ///
  /// This method resets the `page` and `hasMoreData` properties, calls the
  /// `onRefreshData` method (if overridden), and then calls the `getData`
  /// method to fetch the first page of data.
  Future<void> onRefresh() async {
    page = 1;
    hasMoreData = false;
    cancelToken?.cancel();
    await getData();
  }
}
