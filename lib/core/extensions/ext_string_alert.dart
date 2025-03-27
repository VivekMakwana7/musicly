import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/routes/app_router.dart';

/// extension for [String] to show alerts
extension StringAlertX on String {
  /// to show error alert
  void showErrorAlert({Duration? duration}) => navKey.currentContext!.showFlash<void>(
    builder: (context, controller) {
      return FlashBar(
        controller: controller,
        position: FlashPosition.top,
        behavior: FlashBehavior.floating,
        content: Text(this, style: navKey.currentContext!.textTheme.bodyMedium?.copyWith(color: Colors.white)),
        icon: const Icon(Icons.error_outline, color: Color(0xFFE57373)),
        shouldIconPulse: false,
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        forwardAnimationCurve: Curves.bounceOut,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26.r),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      );
    },
    duration: duration ?? const Duration(seconds: 3),
  );

  /// to show success alert
  void showSuccessAlert({Duration? duration}) => navKey.currentContext!.showFlash<void>(
    builder: (context, controller) {
      return FlashBar(
        controller: controller,
        position: FlashPosition.top,
        behavior: FlashBehavior.floating,
        content: Text(this, style: navKey.currentContext!.textTheme.bodyMedium?.copyWith(color: Colors.white)),
        icon: const Icon(Icons.check_circle_outline, color: Color(0xFF81C784)),
        shouldIconPulse: false,
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        forwardAnimationCurve: Curves.bounceOut,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26.r),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
        backgroundColor: const Color(0xFF282C30),
      );
    },
    duration: duration ?? const Duration(seconds: 3),
  );

  /// to show info alert
  void showInfoAlert({Duration? duration}) => navKey.currentContext!.showFlash<void>(
    builder: (context, controller) {
      return FlashBar(
        controller: controller,
        position: FlashPosition.top,
        behavior: FlashBehavior.floating,
        content: Text(this, style: navKey.currentContext!.textTheme.bodyMedium?.copyWith(color: Colors.white)),
        icon: const Icon(Icons.info_outline, color: Color(0xFF64B5F6)),
        shouldIconPulse: false,
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        forwardAnimationCurve: Curves.bounceOut,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26.r),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      );
    },
    duration: duration ?? const Duration(seconds: 3),
  );
}
