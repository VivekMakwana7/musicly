import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/cubits/app/app_cubit.dart';
import 'package:musicly/core/cubits/audio/audio_cubit.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/enums/api_state.dart';
import 'package:musicly/core/extensions/ext_string.dart';
import 'package:musicly/core/source_handler/source_type.dart';
import 'package:musicly/gen/assets.gen.dart';
import 'package:musicly/src/artist/song/cubit/artist_song_cubit.dart';
import 'package:musicly/src/music/sheet/music_sheet_widget.dart';
import 'package:musicly/src/song/widgets/search_song_loading_widget.dart';
import 'package:musicly/widgets/app_back_button.dart';
import 'package:musicly/widgets/app_more_button.dart';
import 'package:musicly/widgets/bottom_nav/audio_widget.dart';
import 'package:musicly/widgets/song_item_widget.dart';

/// Artist Song Page
class ArtistSongPage extends StatelessWidget {
  /// Artist Song Page constructor
  const ArtistSongPage({required this.artistId, super.key});

  /// For get Artist Song  list
  final String artistId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArtistSongCubit(artistId: artistId),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [AppBackButton(), AppMoreButton()],
                ),
                Expanded(
                  child: BlocBuilder<ArtistSongCubit, ArtistSongState>(
                    buildWhen: (previous, current) => current.apiState != previous.apiState,
                    builder: (context, state) {
                      return switch (state.apiState) {
                        ApiState.idle || ApiState.loading => const SearchSongLoadingWidget(needPadding: false),
                        ApiState.success || ApiState.loadingMore => NotificationListener<UserScrollNotification>(
                          onNotification: context.read<ArtistSongCubit>().scrollListener,
                          child: BlocSelector<AudioCubit, AudioState, String?>(
                            selector: (state) => state.song?.id,
                            builder: (context, songId) {
                              return ListView.separated(
                                padding: EdgeInsets.symmetric(vertical: 20.h),
                                itemBuilder: (context, index) {
                                  final song = state.songs[index];
                                  return SongItemWidget(
                                    description: song.label ?? '',
                                    songImageURL: song.image?.last.url ?? '',
                                    title: (song.name ?? '').formatSongTitle,
                                    action:
                                        songId == song.id
                                            ? Assets.json.songPlay.lottie(height: 26.h, width: 26.h)
                                            : IconButton(
                                              icon: Assets.icons.icMore.svg(
                                                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                              ),
                                              onPressed: () {
                                                MusicSheetWidget.show(context, song: song);
                                              },
                                              style: IconButton.styleFrom(
                                                padding: EdgeInsets.zero,
                                                visualDensity: VisualDensity.compact,
                                              ),
                                            ),
                                    onTap: () {
                                      Injector.instance<AppCubit>().artistSongPlayed(artistId);
                                      Injector.instance<AudioCubit>().loadSourceData(
                                        type: SourceType.searchArtist,
                                        songId: state.songs[index].id,
                                        songs: state.songs,
                                        artistId: artistId,
                                        page: context.read<ArtistSongCubit>().page,
                                        isPaginated: true,
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
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const AudioWidget(),
      ),
    );
  }
}
