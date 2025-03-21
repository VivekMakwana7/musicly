import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
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
    final appDb = Injector.instance<AppDB>();

    if (appDb.isHistoryEmpty) {
      return Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Center(
            child: Text(
              'Search your favorite songs, artists, or albums',
              style: context.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: ListView(
        children: [
          if (appDb.songSearchHistory.isNotEmpty) ...[
            SongSearchWidget.fromDatabase(appDb.songSearchHistory),
            SizedBox(height: 20.h),
          ],
          if (appDb.albumSearchHistory.isNotEmpty) ...[
            AlbumSearchWidget.fromDatabase(appDb.albumSearchHistory),
            SizedBox(height: 20.h),
          ],
          if (appDb.artistSearchHistory.isNotEmpty) ...[
            ArtistSearchWidget.fromDatabase(appDb.artistSearchHistory),
            SizedBox(height: 20.h),
          ],
          if (appDb.playlistSearchHistory.isNotEmpty) ...[
            PlayListSearchWidget.fromDatabase(appDb.playlistSearchHistory),
            SizedBox(height: 20.h),
          ],
        ],
      ),
    );
  }
}
