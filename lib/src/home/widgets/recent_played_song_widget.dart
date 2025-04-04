import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/cubits/app/app_cubit.dart';
import 'package:musicly/core/cubits/audio/audio_cubit.dart';
import 'package:musicly/core/cubits/audio/source_handler.dart';
import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/core/extensions/ext_string_alert.dart';
import 'package:musicly/widgets/recent_played_item_widget.dart';

/// Recent Played Song Widget
class RecentPlayedSongWidget extends StatelessWidget {
  /// Recent Played Song Widget constructor
  const RecentPlayedSongWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final recentPlayedSongs = Injector.instance<AppDB>().recentPlayedSong;
    if (recentPlayedSongs.isEmpty) {
      return const SizedBox();
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
          height: 164.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemBuilder: (context, index) {
              final song = recentPlayedSongs.elementAt(index);
              return RecentPlayedItemWidget(
                title: song.name ?? '',
                songImageURL: song.image?.last.url ?? '',
                onTap: () {
                  if (song.downloadUrl?.last.url != null) {
                    Injector.instance<AppCubit>().resetState();
                    Injector.instance<AudioCubit>().loadSourceData(type: SourceType.recentPlayed, songId: song.id);
                  } else {
                    'Audio url not found'.showErrorAlert();
                  }
                },
              );
            },
            separatorBuilder: (context, index) => SizedBox(width: 16.w),
            itemCount: recentPlayedSongs.take(10).length,
          ),
        ),
      ],
    );
  }
}
