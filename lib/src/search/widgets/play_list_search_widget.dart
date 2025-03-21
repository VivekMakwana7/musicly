import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/src/search/cubit/search_cubit.dart';
import 'package:musicly/src/search/model/play_list/global_play_list_model.dart';
import 'package:musicly/widgets/song_item_widget.dart';

/// Play List Search Widget
class PlayListSearchWidget extends StatelessWidget {
  /// Play List Search Widget Constructor
  const PlayListSearchWidget({required this.playlists, super.key});

  /// List of playlists
  final List<GlobalPlayListModel> playlists;

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
            Text('Playlists', style: context.textTheme.titleMedium),
            if (playlists.length >= 3)
              Text('View All', style: context.textTheme.titleSmall?.copyWith(color: const Color(0xFF11A8FD))),
          ],
        ),
        Flexible(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final playlist = playlists[index];
              return SongItemWidget(
                description: playlist.description ?? '',
                songImageURL: playlist.image?.last.url ?? '',
                title: playlist.title ?? '',
                onTap: () {
                  context.read<SearchCubit>().onPlaylistItemTap(index);
                },
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemCount: playlists.length,
          ),
        ),
      ],
    );
  }
}
