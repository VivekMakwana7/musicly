import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// For display music icon
class MusicIcon extends StatelessWidget {
  /// Music Icon Constructor
  const MusicIcon({required this.icon, super.key, this.size = 38, this.onTap});

  /// factory constructor for small icon
  factory MusicIcon.small({required Widget icon, VoidCallback? onTap}) =>
      MusicIcon(icon: icon, size: 38.h, onTap: onTap);

  /// factory constructor for large icon
  factory MusicIcon.large({required Widget icon, VoidCallback? onTap}) =>
      MusicIcon(icon: icon, size: 62.h, onTap: onTap);

  /// factory constructor for extra medium icon
  factory MusicIcon.medium({required Widget icon, VoidCallback? onTap}) =>
      MusicIcon(icon: icon, size: 52.h, onTap: onTap);

  /// For display icon
  final Widget icon;

  /// for change icon size
  final double size;

  /// For handle on tap
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox.square(
        dimension: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFF282C30),
            borderRadius: BorderRadius.circular(40.r),
            border: const Border(top: BorderSide(color: Color(0xFF424750), width: 0.5)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF101012).withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(-8, -8),
              ),
            ],
          ),
          child: Center(child: icon),
        ),
      ),
    );
  }
}
