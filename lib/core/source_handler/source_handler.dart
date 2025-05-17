import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/logger.dart';
import 'package:musicly/core/rest_utils/api_request.dart';
import 'package:musicly/core/source_handler/source_type.dart';
import 'package:musicly/repos/music_repo.dart';

part 'source_data.dart';
part 'recent_played_source_handler.dart';
part 'liked_songs_source_handler.dart';
part 'search_history_source_handler.dart';
part 'playlist_source_handler.dart';
part 'search_source_handler.dart';
part 'search_album_source_handler.dart';
part 'search_artist_source_handler.dart';
part 'search_playlist_source_handler.dart';
part 'downloaded_songs_source_handler.dart';

/// Abstract interface for handlers that fetch song data from various sources.
abstract class SourceHandler {
  /// Retrieves song data from Database
  Future<SourceData> getDatabaseData() {
    return Future.value(SourceData(songs: [], sourceType: sourceType));
  }

  /// Retrieves song data from Search Song
  Future<SourceData> getSearchSongData({required String query, int page = 1}) {
    return Future.value(SourceData(songs: [], sourceType: sourceType));
  }

  /// Retrieves song data from Searched Album songs
  Future<SourceData> getAlbumSongData({required String albumId, int page = 1}) async {
    return Future.value(SourceData(songs: [], sourceType: sourceType));
  }

  /// Retrieves song data for Artist Song
  Future<SourceData> getArtistSongData({required String artistId, int page = 1}) async {
    return Future.value(SourceData(songs: [], sourceType: sourceType, isPaginated: true));
  }

  /// Retrieves song data for Playlist Song
  Future<SourceData> getPlaylistSongData({required String playlistId, int page = 1}) async {
    return Future.value(SourceData(songs: [], sourceType: sourceType));
  }

  /// The type of the data source handled by this instance.
  SourceType get sourceType;

  /// List of Sources
  static List<SourceHandler> sources = [
    RecentPlayedSourceHandler(),
    LikedSongsSourceHandler(),
    SearchHistorySourceHandler(),
    PlaylistSourceHandler(),
    SearchSourceHandler(),
    SearchAlbumSourceHandler(),
    SearchArtistSourceHandler(),
    SearchPlaylistSourceHandler(),
  ];
}
