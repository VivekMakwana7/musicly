import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/core/extensions/ext_string.dart';
import 'package:musicly/core/theme/theme.dart';
import 'package:musicly/routes/app_router.dart';
import 'package:musicly/widgets/network_image_widget.dart';

/// For display Artist Sheet widget
class ArtistSheetWidget extends StatelessWidget {
  /// Default constructor
  const ArtistSheetWidget({required this.song, super.key});

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
            crossAxisAlignment: CrossAxisAlignment.start,
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

              Wrap(
                runSpacing: 6.h,
                spacing: 8.w,
                children: List.generate(
                  (song.artists?.primary ?? []).length,
                  (index) => GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      context.pushNamed(
                        AppRoutes.artistDetailPage,
                        extra: {'artistId': song.artists?.primary?[index].id},
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color(0xFF282C30),
                        borderRadius: BorderRadius.circular(26.r),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                      ),
                      child: Row(
                        spacing: 12.w,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipOval(
                            child: NetworkImageWidget(
                              url: song.artists?.primary?[index].image?.last.url ?? '',
                              height: 54.h,
                              width: 54.h,
                            ),
                          ),
                          Text(
                            song.artists?.primary?[index].name ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodyMedium,
                          ),
                          const SizedBox.shrink(),
                        ],
                      ),
                    ),
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
        return ArtistSheetWidget(song: song);
      },
    );
  }
}
