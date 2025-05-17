import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/core/theme/theme.dart';

/// Common Text Field Widget
class AppTextField extends StatelessWidget {
  /// Common Text Field Widget Constructor
  const AppTextField({this.prefixIcon, this.controller, super.key, this.hintText});

  /// The controller for the text field.
  final TextEditingController? controller;

  /// The prefix icon widget to be displayed at the start of the text field.
  /// This is typically used to show an icon like a search or user icon.
  final Widget? prefixIcon;

  /// For displaying a hint text inside the text field.
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.audioGradientStart, AppColors.audioGradientEnd],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(50.r),
        boxShadow: [
          const BoxShadow(color: AppColors.shadowDark, blurRadius: 15, offset: Offset(-3, -3)),
          BoxShadow(color: AppColors.shadowDarker.withValues(alpha: 0.75), blurRadius: 20, offset: const Offset(4, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2F353A), Color(0xFF1C1F22)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(50.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: TextField(
              controller: controller,
              cursorColor: Colors.white,
              decoration: InputDecoration(
                prefixIconConstraints:
                    prefixIcon != null
                        ? BoxConstraints(maxHeight: 18.h, maxWidth: 18.h, minHeight: 18.h, minWidth: 18.h)
                        : null,
                prefixIcon: prefixIcon,
                hintText: hintText,
                hintStyle: context.textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
