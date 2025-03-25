import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';

/// For display Detail Bio Widget
class DetailBioWidget extends StatelessWidget {
  /// Detail Bio Widget constructor
  const DetailBioWidget({required this.bio, super.key});

  /// For display bio
  final String bio;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 12.h),
        Text(
          bio,
          style: context.textTheme.titleSmall?.copyWith(
            height: 1.1,
            color: const Color(0xFF989CA0),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
