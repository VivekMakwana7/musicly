import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/routes/app_router.dart';
import 'package:musicly/src/search/cubit/search_cubit.dart';
import 'package:musicly/src/search/model/song/global_song_model.dart';
import 'package:musicly/widgets/song_item_widget.dart';

/// Song Search Widget
class SongSearchWidget extends StatelessWidget {
  /// Song Search Widget Constructor
  const SongSearchWidget({super.key, this.songs = const [], this.query});

  /// List of Songs widget
  final List<GlobalSongModel> songs;

  /// For pass it in Search Song page
  final String? query;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12.h,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Songs', style: context.textTheme.titleMedium),
            if (songs.length >= 3)
              TextButton(
                onPressed: () => context.pushNamed(AppRoutes.searchSongPage, extra: {'query': query}),
                style: TextButton.styleFrom(padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
                child: Text('View All', style: context.textTheme.titleSmall?.copyWith(color: const Color(0xFF11A8FD))),
              ),
          ],
        ),
        Flexible(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final song = songs[index];
              return SongItemWidget(
                description: song.description ?? '',
                songImageURL: song.image?.last.url ?? '',
                title: song.title ?? '',
                onTap: () {
                  context.read<SearchCubit>().onSongItemTap(index);
                },
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemCount: songs.length,
          ),
        ),
      ],
    );
  }
}
