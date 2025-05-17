import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:musicly/src/download/download_page.dart';
import 'package:musicly/widgets/bottom_nav/audio_widget.dart';
import 'package:musicly/widgets/bottom_nav/bottom_icons_widget.dart';
import 'package:musicly/widgets/bottom_nav/cubit/bottom_nav_cubit.dart';

/// Bottom Navigation
@immutable
class BottomNav extends StatefulWidget {
  /// Bottom Navigation Constructor
  const BottomNav({required this.child, super.key});

  /// Current navigation shell widget
  final StatefulNavigationShell child;

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  /// Connectivity Instance
  final connection = Connectivity();

  bool havingInternet = false;

  Future<void> _internetChecker() async {
    final list = await connection.checkConnectivity();
    if (list.contains(ConnectivityResult.mobile) ||
        list.contains(ConnectivityResult.ethernet) ||
        list.contains(ConnectivityResult.wifi)) {
      havingInternet = true;
    } else {
      havingInternet = false;
    }
    setState(() {});
    connection.onConnectivityChanged.listen((event) {
      if (event.contains(ConnectivityResult.mobile) ||
          event.contains(ConnectivityResult.ethernet) ||
          event.contains(ConnectivityResult.wifi)) {
        havingInternet = true;
      } else {
        havingInternet = false;
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _internetChecker();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavCubit(),
      child:
          havingInternet
              ? Scaffold(
                body: widget.child,
                bottomNavigationBar: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AudioWidget(),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2C3036), Color(0xFF31343C)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          topRight: Radius.circular(16.r),
                        ),
                        boxShadow: [BoxShadow(color: const Color(0xFF101012).withValues(alpha: 0.5), blurRadius: 30)],
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF2C3036), Color(0xFF31343C)],
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                              ),
                              borderRadius: BorderRadius.circular(50.r),
                              boxShadow: const [
                                BoxShadow(color: Color(0xFF101012), blurRadius: 22.3, offset: Offset(8, 8)),
                                BoxShadow(color: Color(0xFF485057), blurRadius: 22.3, offset: Offset(-5.2, -5.2)),
                              ],
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
                                  child: BottomIconsWidget(child: widget.child),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : const DownloadPage(havingInternet: false),
    );
  }
}
