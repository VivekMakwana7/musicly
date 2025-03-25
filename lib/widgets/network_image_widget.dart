import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/gen/assets.gen.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Netwotk Image Widget
class NetworkImageWidget extends StatelessWidget {
  /// Network Image Widget Constructor
  const NetworkImageWidget({required this.url, super.key, this.height, this.width, this.fit});

  /// Image Network URL
  final String url;

  /// Image Height
  final double? height;

  /// Image Width
  final double? width;

  /// Image Box Fit property
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      key: ValueKey(url),
      imageUrl: url,
      progressIndicatorBuilder:
          (context, url, downloadProgress) => const Skeletonizer(child: ColoredBox(color: Colors.grey)),
      errorWidget:
          (context, url, error) => SizedBox(height: 50.h, width: 50.h, child: Center(child: Assets.icons.icLike.svg())),
      fit: fit,
      height: height,
      width: width,
    );
  }
}
