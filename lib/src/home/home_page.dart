import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/routes/app_router.dart';
import 'package:musicly/src/home/cubit/home_cubit.dart';
import 'package:musicly/src/home/widgets/liked_song_widget.dart';
import 'package:musicly/src/home/widgets/recent_played_song_widget.dart';
import 'package:musicly/src/music/sheet/song_quality_sheet_widget.dart';
import 'package:musicly/widgets/app_setting_button.dart';

/// Home Page
class HomePage extends StatefulWidget {
  /// Home Page Constructor
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (AppDB.settingManager.songQuality == null) {
        SongQualitySheetWidget.show(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(greeting),
          actions: [
            AppSettingButton(
              onTap: () {
                context.pushNamed(AppRoutes.settingPage);
              },
            ),
            SizedBox(width: 16.w),
          ],
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final cubit = context.read<HomeCubit>();
            return ValueListenableBuilder(
              valueListenable: cubit.isHomeEmpty,
              builder: (context, _, _) {
                if (cubit.isHomeEmpty.value) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.w),
                    child: Center(
                      child: Text(
                        'Welcome to Musicly! Start listening to music, and your recent plays will appear here. Tap the heart icon to add your liked songs.',
                        style: context.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 20.h,
                  children: const [SizedBox.shrink(), RecentPlayedSongWidget(), LikedSongWidget()],
                );
              },
            );
          },
        ),
      ),
    );
  }

  /// Returns an appropriate greeting based on the current hour of the day
  String get greeting {
    final hour = DateTime.now().hour;

    if (hour >= 0 && hour < 5) {
      return 'Good Night';
    } else if (hour < 12) {
      return 'Good Morning';
    } else if (hour == 12) {
      return 'Good Noon';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else if (hour < 21) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }
}
