/// Represents different states of an API request
enum ApiState {
  /// [idle] - Initial state before any API call
  idle,

  /// [loading] - API request is in progress
  loading,

  /// [success] - API request completed successfully
  success,

  /// [error] - API request failed with an error
  error,

  /// [empty] - API request succeeded but returned no data
  empty,

  /// [noInternet] - No internet connection available
  noInternet,

  /// [loadingMore] - Loading additional data (e.g. pagination)
  loadingMore,
}
