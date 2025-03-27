import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/src/liked/cubit/like_cubit.dart';
import 'package:musicly/widgets/detail_song_listing_widget.dart';

/// Liked Page
class LikedPage extends StatelessWidget {
  /// Liked Page constructor
  const LikedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LikeCubit(),
      child: Scaffold(
        appBar: AppBar(title: Text(greeting)),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: BlocBuilder<LikeCubit, LikeState>(
            builder: (context, state) {
              final cubit = context.read<LikeCubit>();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20.h),
                  StreamBuilder(
                    stream: cubit.likedSongStream,
                    builder: (context, snapshot) {
                      final list = Injector.instance<AppDB>().likedSongs;
                      return DetailSongListingWidget(songs: list);
                    },
                  ),
                ],
              );
            },
          ),
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
