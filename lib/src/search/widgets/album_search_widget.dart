import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:musicly/core/constants.dart';
import 'package:musicly/core/db/data_base_handler.dart';
import 'package:musicly/core/db/models/album/db_album_model.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/routes/app_router.dart';
import 'package:musicly/src/album/widgets/album_sheet_dialog_widget.dart';
import 'package:musicly/src/search/model/album/global_album_model.dart';
import 'package:musicly/widgets/album_item_widget.dart';

/// Album Search Widget
class AlbumSearchWidget extends StatelessWidget {
  /// Album Search Widget Constructor
  const AlbumSearchWidget({super.key, this.globalAlbums, this.dbAlbums, this.query});

  /// Album Search Widget Constructor from Database
  factory AlbumSearchWidget.fromDatabase(List<DbAlbumModel> albums) {
    return AlbumSearchWidget(dbAlbums: albums);
  }

  /// Album Search Widget Constructor from API
  factory AlbumSearchWidget.api({required List<GlobalAlbumModel> albums, String? query}) {
    return AlbumSearchWidget(globalAlbums: albums, query: query);
  }

  /// List of album results to display in the search widget
  final List<GlobalAlbumModel>? globalAlbums;

  /// List of album results from the local database to display in the search widget
  final List<DbAlbumModel>? dbAlbums;

  /// The search query used to find these album (if applicable).
  final String? query;

  @override
  Widget build(BuildContext context) {
    final songs = globalAlbums ?? dbAlbums ?? [];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12.h,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Albums', style: context.textTheme.titleMedium),
            if (songs.length >= minAlbumsForViewAll)
              TextButton(
                onPressed: () => context.pushNamed(AppRoutes.searchAlbumPage, extra: {'query': query}),
                style: TextButton.styleFrom(padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
                child: Text('View All', style: context.textTheme.titleSmall?.copyWith(color: const Color(0xFF11A8FD))),
              ),
          ],
        ),
        if (globalAlbums != null)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12.h,
              crossAxisSpacing: 12.w,
              childAspectRatio: 1 / 1.7,
            ),
            itemBuilder: (context, index) {
              final album = globalAlbums![index];
              return AlbumItemWidget(
                albumImageURL: album.image?.last.url ?? '',
                title: album.title ?? '',
                description: album.description ?? '',
                onTap: () {
                  context.pushNamed(AppRoutes.albumDetailPage, extra: {'albumId': album.id});
                },
                onMoreTap: () async {
                  final resAlbum = await DatabaseHandler.getAlbumById(album.id);
                  if (resAlbum == null) return;
                  if (context.mounted) AlbumSheetDialogWidget.show(context, album: resAlbum);
                },
              );
            },
            itemCount: globalAlbums!.length,
          ),
        if (dbAlbums != null)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12.h,
              crossAxisSpacing: 12.w,
              childAspectRatio: 1 / 1.7,
            ),
            itemBuilder: (context, index) {
              final album = dbAlbums![index];
              return AlbumItemWidget(
                albumImageURL: album.image?.last.url ?? '',
                title: album.name ?? '',
                description: album.description ?? '',
                onTap: () {
                  context.pushNamed(AppRoutes.albumDetailPage, extra: {'albumId': album.id});
                },
                onMoreTap: () {
                  AlbumSheetDialogWidget.show(context, album: album);
                },
              );
            },
            itemCount: dbAlbums!.take(minDbAlbumCountForDisplay).length,
          ),
      ],
    );
  }
}
