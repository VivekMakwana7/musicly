import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/cubits/audio/audio_cubit.dart';
import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/core/extensions/ext_string_alert.dart';
import 'package:musicly/src/home/cubit/home_cubit.dart';
import 'package:musicly/widgets/recent_played_item_widget.dart';

/// Liked Song Widget
class LikedSongWidget extends StatelessWidget {
  /// Liked Song Widget Constructor
  const LikedSongWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    return StreamBuilder(
      stream: cubit.likedSongStream,
      builder: (_, _) {
        final likedSongs = Injector.instance<AppDB>().likedSongs;
        if (likedSongs.isEmpty) {
          return const SizedBox();
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16.h,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text('Liked songs', style: context.textTheme.titleMedium),
            ),
            SizedBox(
              height: 164.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemBuilder: (context, index) {
                  final song = likedSongs.elementAt(index);
                  return RecentPlayedItemWidget(
                    title: song.name ?? '',
                    songImageURL: song.image?.last.url ?? '',
                    onTap: () {
                      if (song.downloadUrl?.last.url != null) {
                        Injector.instance<AudioCubit>().setLocalSource(song: song, source: likedSongs);
                      } else {
                        'Audio url not found'.showErrorAlert();
                      }
                    },
                  );
                },
                separatorBuilder: (context, index) => SizedBox(width: 16.w),
                itemCount: likedSongs.take(10).length,
              ),
            ),
          ],
        );
      },
    );
  }
}
