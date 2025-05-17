import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/core/theme/theme.dart';
import 'package:musicly/gen/assets.gen.dart';
import 'package:musicly/widgets/network_image_widget.dart';

/// Album Item Widget
class AlbumItemWidget extends StatelessWidget {
  /// Album Item Widget Constructor
  const AlbumItemWidget({
    required this.albumImageURL,
    required this.title,
    required this.description,
    super.key,
    this.onTap,
    this.onMoreTap,
  });

  /// Album Image URL
  final String albumImageURL;

  /// Album Title
  final String title;

  /// Album Description
  final String description;

  /// On Album Item Tap handle
  final VoidCallback? onTap;

  /// For Handle More Tap
  final VoidCallback? onMoreTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18.r),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DecoratedBox(
                    decoration: ShapeDecoration(
                      shape: const CircleBorder(side: BorderSide(color: Color(0xFF424750), width: 0.5)),
                      shadows: [
                        BoxShadow(
                          color: const Color(0xFF262E32).withValues(alpha: 0.7),
                          blurRadius: 20,
                          offset: const Offset(-3, -3),
                        ),
                        const BoxShadow(color: Color(0xFF101012), blurRadius: 20, offset: Offset(4, 4)),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18.r),
                      child: NetworkImageWidget(url: albumImageURL, fit: BoxFit.cover, height: 100.h, width: 100.h),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 4.h,
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            maxLines: description.isEmpty ? 2 : 1,
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
                ],
              ),
            ),
          ),
          if (onMoreTap != null)
            Positioned(
              right: 5,
              top: 5,
              child: IconButton(
                icon: DecoratedBox(
                  decoration: recentPlayedItemDecoration,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Assets.icons.icMore.svg(colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                  ),
                ),
                onPressed: onMoreTap,
                style: IconButton.styleFrom(padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
              ),
            ),
        ],
      ),
    );
  }
}
