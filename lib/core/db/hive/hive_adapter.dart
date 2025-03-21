import 'package:hive_ce/hive.dart';
import 'package:musicly/core/db/models/album/db_album_model.dart';
import 'package:musicly/core/db/models/artist/db_artist_model.dart';
import 'package:musicly/core/db/models/download_url/db_download_url.dart';
import 'package:musicly/core/db/models/image/image_model.dart';
import 'package:musicly/core/db/models/playlist/db_playlist_model.dart';
import 'package:musicly/core/db/models/recent_played_song_model.dart';
import 'package:musicly/core/db/models/search_history_model.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';
import 'package:musicly/core/enums/search_item_type.dart';

part 'hive_adapter.g.dart';

@GenerateAdapters([
  AdapterSpec<SearchHistoryModel>(),
  AdapterSpec<ImageModel>(),
  AdapterSpec<SearchItemType>(),
  AdapterSpec<RecentPlayedSongModel>(),

  // Generated Database Model based on API Call
  AdapterSpec<DbDownloadUrl>(), // Common DB Download Url Model
  AdapterSpec<DbSongModel>(), // Song Model
  AdapterSpec<DbSongArtist>(), // Artist Model
  AdapterSpec<DbSongAllArtist>(), // All Artist Model
  AdapterSpec<DbSongPrimaryArtist>(), // Primary Artist Model
  AdapterSpec<DbSongAlbum>(), // Song Album Model
  AdapterSpec<DbAlbumModel>(), // Album Model
  AdapterSpec<DbArtistModel>(), // Artist Model
  AdapterSpec<Bio>(), // Artist Bio Model
  AdapterSpec<DbPlaylistModel>(), // Playlist Model
])
// This is for code generation
// ignore: unused_element
void _() {}
