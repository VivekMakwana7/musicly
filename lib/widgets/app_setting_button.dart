import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/gen/assets.gen.dart';

/// Common App Setting Button widget
class AppSettingButton extends StatelessWidget {
  /// App Setting Button constructor
  const AppSettingButton({super.key, this.onTap});

  /// For Handle tap event
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF282C30),
          borderRadius: BorderRadius.circular(50.r),
          border: const Border(top: BorderSide(color: Color(0xFF424750), width: 0.5)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF262E32).withValues(alpha: 0.7),
              blurRadius: 20,
              offset: const Offset(-3, -3),
            ),
            BoxShadow(
              color: const Color(0xFF101012).withValues(alpha: 0.75),
              blurRadius: 20,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        child: SizedBox.square(
          dimension: 40.h,
          child: Center(
            child: Assets.icons.icSetting.svg(colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
          ),
        ),
      ),
    );
  }
}
