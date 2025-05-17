import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/widgets/network_image_widget.dart';

/// Artist Item Widget
class ArtistItemWidget extends StatelessWidget {
  /// Artist Item Widget Constructor
  const ArtistItemWidget({required this.artistImageURL, required this.artistName, super.key, this.onTap, this.action});

  /// Artist Image URL
  final String artistImageURL;

  /// Artist Name
  final String artistName;

  /// On Artist Item tap handle
  final VoidCallback? onTap;

  /// For display action widget
  final Widget? action;

  @override
  Widget build(BuildContext context) {
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
        child: Row(
          spacing: 12.w,
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
                  BoxShadow(
                    color: const Color(0xFF101012).withValues(alpha: 0.8),
                    blurRadius: 20,
                    offset: const Offset(4, 4),
                  ),
                ],
              ),
              child: ClipOval(child: SizedBox.square(dimension: 54.h, child: NetworkImageWidget(url: artistImageURL))),
            ),
            Expanded(
              child: Text(
                artistName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodyMedium,
              ),
            ),
            if (action != null) ...[const Spacer(), action!],
          ],
        ),
      ),
    );
  }
}
