import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/widgets/network_image_widget.dart';

/// Common detail page's image view
class DetailImageView extends StatelessWidget {
  /// Detail Image View constructor
  const DetailImageView({required this.imageUrl, super.key, this.dimension});

  /// for display respective image
  final String imageUrl;

  /// For change image dimension
  final double? dimension;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26.r),
        child: NetworkImageWidget(url: imageUrl, width: dimension ?? 160.h, height: dimension ?? 160.h),
      ),
    );
  }
}
