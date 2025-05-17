import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Common Back button for detail page
class AppBackButton extends StatelessWidget {
  /// Default constructor
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pop(),
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
        child: SizedBox.square(dimension: 40.h, child: const Center(child: Icon(Icons.arrow_back_sharp))),
      ),
    );
  }
}
