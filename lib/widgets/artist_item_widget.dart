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
          color: const Color(0xFF282C30),
          borderRadius: BorderRadius.circular(26.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          spacing: 12.w,
          children: [
            ClipOval(child: NetworkImageWidget(url: artistImageURL)),
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
