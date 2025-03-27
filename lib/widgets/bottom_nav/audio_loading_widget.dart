import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/constants.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/gen/assets.gen.dart';
import 'package:musicly/widgets/network_image_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// For display Audio Loading Widget
class AudioLoadingWidget extends StatelessWidget {
  /// Audio Loading Widget Constructor
  const AudioLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Skeletonizer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2C3036), Color(0xFF31343C)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  spacing: 12.w,
                  children: <Widget>[
                    SizedBox.square(dimension: 50.h, child: const ClipOval(child: NetworkImageWidget(url: imageUrl))),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Flexible(child: Text('Song Name', style: context.textTheme.bodyMedium)),
                          Text(
                            'Song description',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Assets.icons.icPrevious.svg(),
                          style: IconButton.styleFrom(padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 240),
                            child: Assets.icons.icPlay.svg(
                              key: const ValueKey('bottom-nav-ic-play'),
                              height: 20.h,
                              colorFilter: const ColorFilter.mode(Color(0xFf7F8489), BlendMode.srcIn),
                            ),
                          ),
                          style: IconButton.styleFrom(padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Assets.icons.icNext.svg(),
                          style: IconButton.styleFrom(padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: SizedBox(
                  height: 6.h,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .3),
                      borderRadius: BorderRadius.all(Radius.circular(6.r)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }
}
