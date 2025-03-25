import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/cubits/audio/audio_cubit.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/theme/theme.dart';
import 'package:musicly/routes/app_router.dart';

/// Entry point of the application
class App extends StatelessWidget {
  /// App constructor
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: Injector.instance<AudioCubit>(),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF353A40), Color(0xFF101010), Color(0xFF121212)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: ScreenUtilInit(
            designSize: const Size(360, 800),
            minTextAdapt: true,
            splitScreenMode: true,
            builder:
                (context, child) => MaterialApp.router(
                  title: 'Musicly App',
                  routerConfig: appRouter,
                  theme: lightTheme,
                  darkTheme: darkTheme,
                  themeMode: ThemeMode.dark,
                ),
          ),
        ),
      ),
    );
  }
}
