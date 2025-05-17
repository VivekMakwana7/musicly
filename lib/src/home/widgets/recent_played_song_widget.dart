import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/cubits/app/app_cubit.dart';
import 'package:musicly/core/cubits/audio/audio_cubit.dart';
import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/core/source_handler/source_type.dart';
import 'package:musicly/src/home/cubit/home_cubit.dart';
import 'package:musicly/widgets/recent_played_item_widget.dart';

/// Recent Played Song Widget
class RecentPlayedSongWidget extends StatelessWidget {
  /// Recent Played Song Widget constructor
  const RecentPlayedSongWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.read<HomeCubit>().recentPlayedStream,
      builder: (context, snapshot) {
        final recentPlayedSongs = AppDB.homeManager.recentPlayedSongs;

        if (recentPlayedSongs.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16.h,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text('Recently played', style: context.textTheme.titleMedium),
            ),
            SizedBox(
              height: 160.h,
              child: BlocSelector<AudioCubit, AudioState, String?>(
                selector: (state) => state.song?.id,
                builder: (context, songId) {
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemBuilder: (context, index) {
                      final song = recentPlayedSongs.elementAt(index);
                      return RecentPlayedItemWidget(
                        song: song,
                        isPlaying: songId == song.id,
                        onTap: () {
                          Injector.instance<AppCubit>().resetState();
                          Injector.instance<AudioCubit>().loadSourceData(
                            type: SourceType.recentPlayed,
                            songId: song.id,
                            page: 0,
                            isPaginated: false,
                            songs: recentPlayedSongs,
                          );
                        },
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(width: 16.w),
                    itemCount: recentPlayedSongs.take(10).length,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
