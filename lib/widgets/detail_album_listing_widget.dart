import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:musicly/core/constants.dart';
import 'package:musicly/core/db/data_base_handler.dart';
import 'package:musicly/core/db/models/album/db_album_model.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/routes/app_router.dart';
import 'package:musicly/src/album/widgets/album_sheet_dialog_widget.dart';
import 'package:musicly/widgets/album_item_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// for display Album listing
class DetailAlbumListingWidget extends StatelessWidget {
  /// Album listing constructor
  const DetailAlbumListingWidget({required this.albums, super.key, this.onViewAllTap, this.title});

  /// For loading
  factory DetailAlbumListingWidget.loading() => const DetailAlbumListingWidget(albums: []);

  /// List of Albums
  final List<DbAlbumModel> albums;

  /// For handle View all tap
  final VoidCallback? onViewAllTap;

  /// For change title
  final String? title;

  @override
  Widget build(BuildContext context) {
    final isLoading = albums.isEmpty;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 30.h),
        Skeletonizer(
          enabled: isLoading,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title ?? 'Top Albums'),
              if (onViewAllTap != null)
                TextButton(
                  onPressed: onViewAllTap,
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
                  child: Text(
                    'View All',
                    style: context.textTheme.titleSmall?.copyWith(color: const Color(0xFF11A8FD)),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 166.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final image = isLoading ? imageUrl : albums[index].image?.last.url ?? '';
              final title = isLoading ? 'Album name' : albums[index].name ?? '';
              final description = isLoading ? 'Album' : albums[index].description ?? '';
              return SizedBox(
                width: 104.w,
                child: Skeletonizer(
                  enabled: isLoading,
                  child: AlbumItemWidget(
                    albumImageURL: image,
                    title: title,
                    description: description,
                    onTap: () {
                      if (!isLoading) {
                        context.pushNamed(AppRoutes.albumDetailPage, extra: {'albumId': albums[index].id});
                      }
                    },
                    onMoreTap: () async {
                      final resAlbum = await DatabaseHandler.getAlbumById(albums[index].id);
                      if (resAlbum == null) return;
                      if (context.mounted) AlbumSheetDialogWidget.show(context, album: resAlbum);
                    },
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            itemCount: albums.length,
          ),
        ),
      ],
    );
  }
}
