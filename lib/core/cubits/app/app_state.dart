part of 'app_cubit.dart';

/// AppState
@immutable
sealed class AppState {}

///
final class AppInitial extends AppState {}

/// State for Song Like Update
final class SongLikeUpdate extends AppState {
  /// Constructor
  SongLikeUpdate({required this.songId, required this.isLiked});

  /// Song Id
  final String songId;

  /// Is Liked
  final bool isLiked;
}
