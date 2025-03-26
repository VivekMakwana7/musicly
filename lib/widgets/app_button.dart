import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Common App Button
class AppButton extends StatelessWidget {
  /// Default constructor
  const AppButton({required this.name, super.key, this.onTap});

  /// For handle on tap
  final VoidCallback? onTap;

  /// For change button name
  final String name;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF016BB8), Color(0xFF11A8FD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(26.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 14.h),
          child: Center(child: Text(name)),
        ),
      ),
    );
  }
}
