import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// App Animated Switcher Widget
class AppAnimatedSwitcher extends StatefulWidget {
  /// Constructor
  const AppAnimatedSwitcher({required this.value, super.key, this.onChanged});

  /// Current Switcher Value
  final bool value;

  /// For change updated value
  final ValueChanged<bool?>? onChanged;

  @override
  State<AppAnimatedSwitcher> createState() => _AppAnimatedSwitcherState();
}

class _AppAnimatedSwitcherState extends State<AppAnimatedSwitcher> {
  late bool _value = widget.value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _value = !_value;
        setState(() {});

        widget.onChanged?.call(_value);
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        decoration: ShapeDecoration(
          shape: const StadiumBorder(),
          gradient: LinearGradient(
            colors:
                _value
                    ? [const Color(0xFF016BB8), const Color(0xFF11A8FD)]
                    : [const Color(0xFF2F353A), const Color(0xFF1C1F22)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shadows: [
            BoxShadow(
              offset: const Offset(2, 2),
              color: const Color(0xFF000000).withValues(alpha: 0.06),
              blurRadius: 4,
            ),
            BoxShadow(
              offset: const Offset(-2, -2),
              color: const Color(0xFF000000).withValues(alpha: 0.5),
              blurRadius: 5,
            ),
          ],
        ),
        child: SizedBox(
          width: 40.w,
          height: 24.h,
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: AnimatedAlign(
              alignment: _value ? Alignment.centerRight : Alignment.centerLeft,
              duration: const Duration(milliseconds: 240),
              child: DecoratedBox(
                decoration: const ShapeDecoration(shape: CircleBorder(), color: Colors.white),
                child: SizedBox.square(dimension: 20.h),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
