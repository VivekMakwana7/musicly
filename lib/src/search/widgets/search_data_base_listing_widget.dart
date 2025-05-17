import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/src/search/widgets/album_search_widget.dart';
import 'package:musicly/src/search/widgets/artist_search_widget.dart';
import 'package:musicly/src/search/widgets/play_list_search_widget.dart';
import 'package:musicly/src/search/widgets/song_search_widget.dart';

/// Search data base listing widget
class SearchDataBaseListingWidget extends StatelessWidget {
  /// Search data base listing widget constructor
  const SearchDataBaseListingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        children: [
          if (AppDB.searchManager.searchedSongs.isNotEmpty) ...[
            SongSearchWidget.fromDatabase(AppDB.searchManager.searchedSongs),
            SizedBox(height: 20.h),
          ],
          if (AppDB.searchManager.searchedAlbums.isNotEmpty) ...[
            AlbumSearchWidget.fromDatabase(AppDB.searchManager.searchedAlbums),
            SizedBox(height: 20.h),
          ],
          if (AppDB.searchManager.searchedArtists.isNotEmpty) ...[
            ArtistSearchWidget.fromDatabase(AppDB.searchManager.searchedArtists),
            SizedBox(height: 20.h),
          ],
          if (AppDB.searchManager.searchedPlaylists.isNotEmpty) ...[
            PlayListSearchWidget.fromDatabase(AppDB.searchManager.searchedPlaylists),
            SizedBox(height: 20.h),
          ],
        ],
      ),
    );
  }
}
