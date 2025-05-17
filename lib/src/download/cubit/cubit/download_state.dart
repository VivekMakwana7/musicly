part of 'download_cubit.dart';

/// Download State
final class DownloadState {
  /// Download State Constructor
  const DownloadState({
    this.songs = const [],
  });
 
///
 final List<DbSongModel> songs;


  /// Copy with
  DownloadState copyWith({
   
    List<DbSongModel>? songs,
   
  }) {
    return DownloadState(
   
      songs: songs ?? this.songs,
   
    );
  }
}
