import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/core/extensions/ext_string.dart';
import 'package:musicly/core/theme/theme.dart';
import 'package:musicly/gen/assets.gen.dart';
import 'package:musicly/widgets/network_image_widget.dart';

/// Song Item Widget
class SongItemWidget extends StatelessWidget {
  /// Song Item Widget Constructor
  const SongItemWidget({
    required this.songImageURL,
    required this.description,
    required this.title,
    required this.action,
    super.key,
    this.onTap,
    this.isPlaying = false,
  });

  /// Song Image URL
  final String songImageURL;

  /// Song Title
  final String title;

  /// Song Description
  final String description;

  /// On Tap
  final VoidCallback? onTap;

  /// For display action widget
  final Widget action;

  /// For display playing animated icon
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = NetworkImageWidget(url: songImageURL, height: 52.h, width: 52.h, fit: BoxFit.cover);
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
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF1C1F22),
          borderRadius: BorderRadius.circular(26.r),
          border: const Border(top: BorderSide(color: Color(0xFF424750), width: 0.5)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF262E32).withValues(alpha: 0.7),
              blurRadius: 20,
              offset: const Offset(-3, -3),
            ),
            BoxShadow(
              color: const Color(0xFF101012).withValues(alpha: 0.75),
              blurRadius: 20,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(15.w),
          child: Row(
            spacing: 12.w,
            children: [
              ClipRRect(borderRadius: BorderRadius.circular(12.r), child: imageWidget),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4.h,
                  children: [
                    Flexible(
                      child: Text(
                        title.formatSongTitle,
                        maxLines: description.isNotEmpty ? 1 : 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodyMedium,
                      ),
                    ),
                    if (description.isNotEmpty)
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                  ],
                ),
              ),
              action,
            ],
          ),
        ),
      ),
    );
  }
}
