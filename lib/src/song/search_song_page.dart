import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/cubits/app/app_cubit.dart';
import 'package:musicly/core/cubits/audio/audio_cubit.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/enums/api_state.dart';
import 'package:musicly/core/extensions/ext_string.dart';
import 'package:musicly/core/source_handler/source_type.dart';
import 'package:musicly/src/song/cubit/search_song_cubit.dart';
import 'package:musicly/src/song/widgets/search_song_loading_widget.dart';
import 'package:musicly/widgets/bottom_nav/audio_widget.dart';
import 'package:musicly/widgets/song_item_widget.dart';
import 'package:musicly/widgets/song_play_more_widget.dart';

/// Search Song Page
class SearchSongPage extends StatelessWidget {
  /// Search Song Page constructor
  const SearchSongPage({super.key, this.query});

  /// For search songs
  final String? query;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchSongCubit(query: query),
      child: Scaffold(
        appBar: AppBar(title: const Text('Search songs')),
        body: BlocBuilder<SearchSongCubit, SearchSongState>(
          buildWhen: (previous, current) => current.apiState != previous.apiState,
          builder: (context, state) {
            return switch (state.apiState) {
              ApiState.idle || ApiState.loading => const SearchSongLoadingWidget(),
              ApiState.success || ApiState.loadingMore => NotificationListener<UserScrollNotification>(
                onNotification: context.read<SearchSongCubit>().scrollListener,
                child: BlocSelector<AudioCubit, AudioState, String?>(
                  selector: (state) => state.song?.id,
                  builder: (context, songId) {
                    return ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                      itemBuilder: (context, index) {
                        final song = state.songs[index];
                        return SongItemWidget(
                          description: song.label ?? '',
                          songImageURL: song.image?.last.url ?? '',
                          title: (song.name ?? '').formatSongTitle,
                          action: SongPlayMoreWidget.song(song: song),
                          isPlaying: songId == song.id,
                          onTap: () {
                            Injector.instance<AppCubit>().resetState();
                            Injector.instance<AudioCubit>().loadSourceData(
                              query: query ?? '',
                              songId: song.id,
                              page: context.read<SearchSongCubit>().page,
                              type: SourceType.search,
                              songs: state.songs,
                              isPaginated: false,
                            );
                          },
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(height: 16.h),
                      itemCount: state.songs.length,
                    );
                  },
                ),
              ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
        bottomNavigationBar: const AudioWidget(),
      ),
    );
  }
}
