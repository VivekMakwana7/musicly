import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Common Back button for detail page
class BackButton extends StatelessWidget {
  /// Default constructor
  const BackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pop(),
      behavior: HitTestBehavior.opaque,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2F353A), Color(0xFF1C1F22)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: SizedBox.square(dimension: 40.h, child: const Center(child: Icon(Icons.arrow_back_sharp))),
      ),
    );
  }
}
