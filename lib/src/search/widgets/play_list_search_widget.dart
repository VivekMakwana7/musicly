import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:musicly/core/constants.dart';
import 'package:musicly/core/db/models/playlist/db_playlist_model.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/routes/app_router.dart';
import 'package:musicly/src/search/model/play_list/global_play_list_model.dart';
import 'package:musicly/widgets/song_item_widget.dart';

/// Play List Search Widget
class PlayListSearchWidget extends StatelessWidget {
  /// Play List Search Widget Constructor
  const PlayListSearchWidget({this.globalPlaylists, this.dbPlayLists, this.query, super.key});

  /// Play List Search Widget Constructor from API
  factory PlayListSearchWidget.api({required List<GlobalPlayListModel> playlists, String? query}) {
    return PlayListSearchWidget(globalPlaylists: playlists, query: query);
  }

  /// Play List Search Widget Constructor from Database
  factory PlayListSearchWidget.fromDatabase(List<DbPlaylistModel> playlists) {
    return PlayListSearchWidget(dbPlayLists: playlists);
  }

  /// List of playlists
  final List<GlobalPlayListModel>? globalPlaylists;

  /// List of playlists from the local database to display in the search widget
  final List<DbPlaylistModel>? dbPlayLists;

  /// The search query used to find these playlists (if applicable).
  final String? query;

  @override
  Widget build(BuildContext context) {
    final playlists = globalPlaylists ?? dbPlayLists ?? [];
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12.h,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Playlists', style: context.textTheme.titleMedium),
            if (playlists.length >= minPlaylistForViewAll)
              TextButton(
                onPressed: () => context.pushNamed(AppRoutes.searchPlaylistPage, extra: {'query': query}),
                style: TextButton.styleFrom(padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
                child: Text('View All', style: context.textTheme.titleSmall?.copyWith(color: const Color(0xFF11A8FD))),
              ),
          ],
        ),
        if (globalPlaylists != null)
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final playlist = globalPlaylists![index];
                return SongItemWidget(
                  description: playlist.description ?? '',
                  songImageURL: playlist.image?.last.url ?? '',
                  title: playlist.title ?? '',
                  onTap: () {
                    context.pushNamed(AppRoutes.playlistDetailPage, extra: {'playlistId': playlist.id});
                  },
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 16.h),
              itemCount: globalPlaylists!.length,
            ),
          ),
        if (dbPlayLists != null)
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final playlist = dbPlayLists![index];
                return SongItemWidget(
                  description: playlist.description ?? '',
                  songImageURL: playlist.image?.last.url ?? '',
                  title: playlist.name ?? '',
                  onTap: () {
                    context.pushNamed(AppRoutes.playlistDetailPage, extra: {'playlistId': playlist.id});
                  },
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 16.h),
              itemCount: dbPlayLists!.take(minDbPlaylistCountForDisplay).length,
            ),
          ),
      ],
    );
  }
}
