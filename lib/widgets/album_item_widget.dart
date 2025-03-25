import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
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
  });

  /// Album Image URL
  final String albumImageURL;

  /// Album Title
  final String title;

  /// Album Description
  final String description;

  /// On Album Item Tap handle
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFF282C30),
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18.r),
                child: NetworkImageWidget(url: albumImageURL, fit: BoxFit.cover, height: 100.h, width: 100.h),
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
    );
  }
}
