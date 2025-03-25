import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/widgets/network_image_widget.dart';

/// Recent Played Item Widget
class RecentPlayedItemWidget extends StatelessWidget {
  /// Recent Played Item Widget constructor
  const RecentPlayedItemWidget({required this.songImageURL, required this.title, super.key, this.onTap});

  /// Song Image URL
  final String songImageURL;

  /// Song Title
  final String title;

  /// For handle Item on Tap
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 110.w,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFF282C30),
            borderRadius: BorderRadius.circular(26.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              spacing: 12.h,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: NetworkImageWidget(url: songImageURL, height: 76.h, width: 76.h),
                ),
                Text(
                  title,
                  style: context.textTheme.bodyMedium?.copyWith(color: const Color(0xFF989CA0)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
