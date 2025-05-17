import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/core/extensions/ext_string.dart';
import 'package:musicly/core/theme/theme.dart';
import 'package:musicly/gen/assets.gen.dart';
import 'package:musicly/widgets/network_image_widget.dart';
import 'package:musicly/widgets/song_play_more_widget.dart';

/// Recent Played Item Widget
class RecentPlayedItemWidget extends StatelessWidget {
  /// Recent Played Item Widget constructor
  const RecentPlayedItemWidget({required this.song, super.key, this.onTap, this.isPlaying = false});

  /// For handle Item on Tap
  final VoidCallback? onTap;

  /// For handle Item is Playing
  final bool isPlaying;

  /// For display current song
  final DbSongModel song;

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = NetworkImageWidget(url: song.image?.last.url ?? '', height: 76.h, width: 76.h);
    if (isPlaying) {
      imageWidget = Stack(
        children: [
          imageWidget,
          Positioned.fill(
            child: ColoredBox(
              color: AppColors.primary.withValues(alpha: 0.8),
              child: Center(child: Assets.json.songPlay.lottie(height: 20.h, width: 20.h)),
            ),
          ),
        ],
      );
    }
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          SizedBox(
            width: 110.w,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(26.r),
                border: const Border(top: BorderSide(color: AppColors.borderTop, width: 0.5)),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  spacing: 12.h,
                  children: [
                    ClipRRect(borderRadius: BorderRadius.circular(16.r), child: imageWidget),
                    Text(
                      (song.name ?? '').formatSongTitle,
                      style: context.textTheme.bodyMedium?.copyWith(height: 1.3),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(right: 5, top: 5, child: SongPlayMoreWidget.song(song: song, isDecorated: true)),
        ],
      ),
    );
  }
}
