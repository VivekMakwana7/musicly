import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/widgets/network_image_widget.dart';

/// Song Item Widget
class SongItemWidget extends StatelessWidget {
  /// Song Item Widget Constructor
  const SongItemWidget({
    required this.songImageURL,
    required this.description,
    required this.title,
    super.key,
    this.onTap,
  });

  /// Song Image URL
  final String songImageURL;

  /// Song Title
  final String title;

  /// Song Description
  final String description;

  /// On Tap
  final VoidCallback? onTap;

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
        child: Padding(
          padding: EdgeInsets.all(15.w),
          child: Row(
            spacing: 12.w,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: NetworkImageWidget(url: songImageURL, height: 52.h, width: 52.h, fit: BoxFit.cover),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4.h,
                  children: [
                    Flexible(
                      child: Text(
                        title,
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
            ],
          ),
        ),
      ),
    );
  }
}
