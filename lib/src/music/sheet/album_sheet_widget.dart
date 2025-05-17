import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/core/extensions/ext_string.dart';
import 'package:musicly/core/theme/theme.dart';
import 'package:musicly/routes/app_router.dart';
import 'package:musicly/widgets/album_item_widget.dart';
import 'package:musicly/widgets/network_image_widget.dart';

/// For display Album Sheet widget
class AlbumSheetWidget extends StatelessWidget {
  /// Default constructor
  const AlbumSheetWidget({required this.song, super.key});

  /// Display song detail in sheet
  final DbSongModel song;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      child: DecoratedBox(
        decoration: sheetDecoration,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                spacing: 12.w,
                children: [
                  SizedBox.square(
                    dimension: 50.h,
                    child: ClipOval(child: NetworkImageWidget(url: song.image?.last.url ?? '')),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Flexible(
                          child: Text(
                            (song.name ?? '').formatSongTitle,
                            maxLines: (song.label ?? '').isNotEmpty ? 1 : 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodyMedium,
                          ),
                        ),
                        if ((song.label ?? '').isNotEmpty)
                          Text(
                            song.label ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),

              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 176.h,
                  width: 98.w,
                  child: AlbumItemWidget(
                    title: song.album?.name ?? '',
                    albumImageURL: song.image?.last.url ?? '',
                    description: '',
                    onTap: () {
                      Navigator.of(context).pop();
                      context.pushNamed(AppRoutes.albumDetailPage, extra: {'albumId': song.album?.id});
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// For show sheet
  static void show(BuildContext context, {required DbSongModel song}) {
    showModalBottomSheet<dynamic>(
      context: context,
      scrollControlDisabledMaxHeightRatio: 0.8,
      builder: (context) {
        return AlbumSheetWidget(song: song);
      },
    );
  }
}
