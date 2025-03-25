import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:musicly/widgets/bottom_nav/audio_widget.dart';
import 'package:musicly/widgets/bottom_nav/bottom_icons_widget.dart';
import 'package:musicly/widgets/bottom_nav/cubit/bottom_nav_cubit.dart';

/// Bottom Navigation
@immutable
class BottomNav extends StatelessWidget {
  /// Bottom Navigation Constructor
  const BottomNav({required this.child, super.key});

  /// Current navigation sheel widget
  final StatefulNavigationShell child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavCubit(),
      child: Scaffold(
        body: child,
        bottomNavigationBar: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF353A40), Color(0xFF32373D), Color(0xFF23282C)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(16.r), topRight: Radius.circular(16.r)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AudioWidget(),
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2C3036), Color(0xFF31343C)],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.circular(50.r),
                      boxShadow: const [BoxShadow(color: Color(0xFF353A40), blurRadius: 15, spreadRadius: 10)],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(2.w),
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
                          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                          child: BottomIconsWidget(child: child),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
